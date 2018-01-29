//
//  EditProfileViewController.swift
//  MyHomeBuy
//
//  Created by Vikas on 12/10/17.
//  Copyright © 2017 MobileCoderz. All rights reserved.
//

import UIKit
import SDWebImage
import MBProgressHUD
import SwiftyJSON
class EditProfileViewController: UIViewController {
    let  imagePicker =  UIImagePickerController()

    @IBOutlet weak var navigationBarView: UIView!
    @IBOutlet weak var profileBgView: UIView!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    var imageArray = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        //frostedViewController.panGestureEnabled = false
        setupUI()
        navigationBarView.setBottomShadow()

    }
    func setupUI(){
        let radius = 5
        emailTextField.keyboardType = .emailAddress
        phoneTextField.keyboardType = .numberPad
        nameTextField.setRadius(CGFloat(radius))
        phoneTextField.setRadius(CGFloat(radius))
        emailTextField.setRadius(CGFloat(radius))
        addressTextField.setRadius(CGFloat(radius))
        nameTextField.applyPadding(padding: 5)
        phoneTextField.applyPadding(padding: 5)
        emailTextField.applyPadding(padding: 5)
        addressTextField.applyPadding(padding: 5)
        bgView.setRadius(5)
        profileBgView.setRadius(profileBgView.frame.size.width/2, .lightGray)
        saveBtn.setRadius(10)
        cancelBtn.setRadius(10)
        if let userImage = UserDefaults.standard.object(forKey: USER_IMAGE){
            let url = userImage as? String
            profileImageView.sd_setImage(with: URL(string: url!), placeholderImage: UIImage(named: "user_icon"))
           
        }
        let userName = UserDefaults.standard.object(forKey: USER_NAME)
        nameTextField.text  = userName as? String
        let userEmail = UserDefaults.standard.object(forKey: USER_EMAIL)
         emailTextField.text = userEmail as? String
        
        if let userPhone = UserDefaults.standard.object(forKey: USER_CONTACT_NUMBER){
            phoneTextField.text = userPhone as? String
        }
        
        if let userAddress = UserDefaults.standard.object(forKey: USER_ADDRESS){
            addressTextField.text = userAddress as? String
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        frostedViewController.panGestureEnabled = false
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    @IBAction func backBtnPressed(_ sender: Any) {
        if let navCon = navigationController{
            navCon.popViewController(animated: true)
        }
    }
    
    @IBAction func homeButtonPressed(_ sender: Any) {
        let navController : UINavigationController  = storyboard?.instantiateViewController(withIdentifier: "SlidingNavigationController") as! UINavigationController
        var controller: UIViewController!
        
        controller = storyboard?.instantiateViewController(withIdentifier: "MyHomeViewController") as? MyHomeViewController
        
        navController.viewControllers = [controller]
        
        frostedViewController.contentViewController = navController
    
    }
    
    
    @IBAction func cameraBtnPressed(_ sender: Any) {
        let actionSheetController = UIAlertController(title: NSLocalizedString("Capture Photo", comment: "nil"), message: "", preferredStyle: .actionSheet)
        
        let cancelActionButton = UIAlertAction(title: NSLocalizedString("Cancel", comment: "nil"), style: .cancel) { action -> Void in
            print("Cancel")
        }
        actionSheetController.addAction(cancelActionButton)
        
        let saveActionButton = UIAlertAction(title: NSLocalizedString("Camera", comment: "nil"), style: .default) { action -> Void in
            print("Camera")
            self.capturePhotoFromCamera()
        }
        actionSheetController.addAction(saveActionButton)
        
        let deleteActionButton = UIAlertAction(title: NSLocalizedString("Gallery", comment: "nil"), style: .default) { action -> Void in
            print("Gallery")
            self.capturePhotoFromLibrary()
        }
        actionSheetController.addAction(deleteActionButton)
        self.present(actionSheetController, animated: true, completion: nil)
    }
    func capturePhotoFromCamera(){
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            present(imagePicker, animated: true, completion: nil)
        }else{
            self.view.makeToast(CAMERA_ERROR)
        }
    }
    func capturePhotoFromLibrary(){
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    @IBAction func cancelBtnPressed(_ sender: Any) {
        if let navCon = navigationController{
            navCon.popViewController(animated: true)
        }
    }
    
    @IBAction func saveBtnPressed(_ sender: Any) {
        
        if(nameTextField.text?.isEmpty)!{
            view.makeToast("Please enter name")
        }else if(addressTextField.text?.isEmpty)!{
            view.makeToast("Please enter your address")
            
        }else if(emailTextField.text?.isEmpty)!{
            view.makeToast("Please enter your email")
        }else if(!(emailTextField.text?.isValidEmail())!){
            view.makeToast("Please enter valid email")
        }else if(phoneTextField.text?.isEmpty)!{
            view.makeToast("Please enter your Phone Number")

        }else if(!(phoneTextField.text?.isLengthValidWithRange(8,16))!){
        view.makeToast("Please enter valid Phone Number")
        }else{
            requestEditProfileAPI()
        }
    }
    
    func requestEditProfileAPI(){
       // address,user_id,email,image,phone_number,userName
        let userId = UserDefaults.standard.object(forKey: USER_ID) as! String
        let parmDict = ["user_id" : userId , "address" : addressTextField.text!,"email" : emailTextField.text! ,"phone_number" : phoneTextField.text! ,"userName" : nameTextField.text! ,"method_name" : ApiUrl.METHOD_EDIT_PROFILE_URL ] as [String : Any]
        MBProgressHUD.showAdded(to: self.view, animated: true)
        ApiManager.sharedInstance.requestApiServer(parmDict, imageArray, {(userJson) ->() in
            let jsondata = JSON(userJson)
            
            print("success  \(jsondata)")
            self.profileUpdated(userJson)

            if(jsondata["status"].intValue == 1){
                //                let signupVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WalkThroughViewController") as! WalkThroughViewController
                //                self.navigationController?.pushViewController(signupVC, animated: true)
                self.view.makeToast("Profile Updated Successfully")
                
            }else{
                
            }
            
            
            MBProgressHUD.hide(for: self.view, animated: true)
        }, {(error)-> () in
            print("failure \(error)")
            MBProgressHUD.hide(for: self.view, animated: true)
            self.view.makeToast(NETWORK_ERROR)
            
            
        },{(progress)-> () in
            print("progress \(progress)")
            
        })
        
    }
    func profileUpdated(_ userData : Any){
        
        let jsondata = JSON(userData)
        print("success data  \(jsondata)")
        let userDataModel = UserBase(dictionary: userData as! NSDictionary)
        if(userDataModel?.status == 1){
            saveDataToUserDefaults(userDataModel!)
          SharedAppDelegate.window?.makeToast("Profile updated successfully")
            if let navCon = navigationController{
                navCon.popViewController(animated: true)
            }
            
        }else{
            
            self.view.makeToast("Unable to update profile")
        }
    }
    func saveDataToUserDefaults(_ userDataModel : UserBase){
        UserDefaults.standard.set(userDataModel.data?.pin_number, forKey: USER_PIN)
        UserDefaults.standard.set(userDataModel.data?.userName, forKey: USER_NAME)
        UserDefaults.standard.set(userDataModel.data?.address, forKey: USER_ADDRESS)
        UserDefaults.standard.set(userDataModel.data?.email, forKey: USER_EMAIL)
        UserDefaults.standard.set(userDataModel.data?.image, forKey: USER_IMAGE)
        UserDefaults.standard.set(userDataModel.data?.phone_number, forKey: USER_CONTACT_NUMBER)
        //let id =  "\()"
        UserDefaults.standard.set(userDataModel.data?.id, forKey: USER_ID)
        UserDefaults.standard.synchronize()
    }
}

extension EditProfileViewController : UINavigationControllerDelegate{
    
}

extension EditProfileViewController : UIImagePickerControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        imageArray.removeAll()
        imagePicker.allowsEditing = true
        imagePicker.dismiss(animated: true, completion: nil)
        profileImageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        let capturedImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        guard let image = capturedImage else{return}
        let size = CGSize(width: 200, height: 200)
        guard let finalImage = image.resize(size, 0.5) else{return}
       imageArray.append(finalImage)
    }
    
}
