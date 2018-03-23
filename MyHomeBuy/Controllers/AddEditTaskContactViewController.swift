//
//  AddEditTaskContactViewController.swift
//  MyHomeBuy
//
//  Created by Vikas on 06/11/17.
//  Copyright © 2017 MobileCoderz. All rights reserved.
//

import UIKit
import MBProgressHUD
import Toast_Swift

protocol ContactUpdatedDelegate {
    func contactUpdated()
}
class AddEditTaskContactViewController: UIViewController {
    enum CurrentScreenType : String {
        case ADD_SCREEN = "add"
        case EDIT_SCREEN = "edit"
        
    }
    var fromTask = false

    @IBOutlet weak var headingHeightConstraint: NSLayoutConstraint!
    let  imagePicker =  UIImagePickerController()
    var imageArray = [UIImage]()
    @IBOutlet weak var profileViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var leftBtn: UIButton!
    
    @IBOutlet weak var rightBtn: UIButton!
    @IBOutlet weak var contactLbl: UILabel!
    @IBOutlet weak var contactImageView: UIImageView!
    @IBOutlet weak var contactHeadingView: UIView!
    @IBOutlet weak var navigationBarView: UIView!
    
    @IBOutlet weak var profileContainerView: UIView!
    @IBOutlet weak var currentTitle: UILabel!
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var phoneNoLbl: UILabel!
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var initialLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    
    @IBOutlet weak var phoneNoTextfield: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var addressTextView: UITextView!
    var dataDict = NSDictionary()
    var delegate : ContactUpdatedDelegate?
    var currentScreen = CurrentScreenType.EDIT_SCREEN.rawValue
    var model = AddContactModel(dictionary: ["" : ""])
    var currentTaskID = "0"
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
//        navigationBarView.setBottomShadow()
//        contactHeadingView.setBottomShadow()
        setupData()
        if(fromTask){
            setupHeaderData()
        }else{
            headingHeightConstraint.constant = 0
        }
    }
    func setupData(){
        nameTextField.applyPadding(padding: 5)
        phoneTextField.applyPadding(padding: 5)
        emailTextField.applyPadding(padding: 5)
        addressTextView.delegate  = self
        phoneTextField.keyboardType = .numberPad
        emailTextField.keyboardType = .emailAddress
        leftBtn.setRadius(10)
        rightBtn.setRadius(10)
        profileContainerView.setRadius(5)
        profileView.setRadius(profileView.frame.size.width/2)
        initialLbl.text = model?.name?.getInitials("")
        
        if(currentScreen == CurrentScreenType.ADD_SCREEN.rawValue){
            currentTitle.text = "Add Contact"
            profileViewHeightConstraint.constant = 0
            
            leftBtn.setTitle("CANCEL", for: .normal)
            rightBtn.setTitle("SAVE", for: .normal)
            leftBtn.addTarget(self, action: #selector(cancelBtnPressed(_:)), for: .touchUpInside)
            rightBtn.addTarget(self, action: #selector(saveBtnPressed(_:)), for: .touchUpInside)
            
        }else{
            setEditContactData()
            currentTitle.text = "Edit Contact"
            profileViewHeightConstraint.constant = 100
            leftBtn.setTitle("CANCEL", for: .normal)
            rightBtn.setTitle("SAVE", for: .normal)
            leftBtn.addTarget(self, action: #selector(removeBtnPressed(_:)), for: .touchUpInside)
            rightBtn.addTarget(self, action: #selector(doneBtnPressed(_:)), for: .touchUpInside)
        }
       
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        navigationBarView.setBottomShadow()
        contactHeadingView.setBottomShadow()
    }
    func setupHeaderData(){
        let image = UIImage.init(named: (dataDict.object(forKey: "image_white") as! String?)!)
        contactImageView.image = image
        let title = dataDict.object(forKey: "headerText") as! String?
        contactLbl.text = title
    }
    func setEditContactData(){
        nameTextField.text = model?.name
        phoneTextField.text = model?.phone_number
        emailTextField.text = model?.email
        if(model?.image == ""){
            
        }else{
            profileImageView.sd_setImage(with: URL(string: (model?.image)!))
        }
//        if(model?.address == ""){
//            addressTextView.text = addressStr
//        }else{
            addressTextView.text = model?.address
            
       // }
        
        nameLbl.text = model?.name
        phoneNoLbl.text = String.phoneNumberFormate(num: (model?.phone_number)!)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        if let navCon = navigationController{
            navCon.popViewController(animated: true)
        }
    }
    
    @IBAction func homeBtnPressed(_ sender: Any) {
        let navController : UINavigationController  = storyboard?.instantiateViewController(withIdentifier: "SlidingNavigationController") as! UINavigationController
        var controller: UIViewController!
        
        controller = storyboard?.instantiateViewController(withIdentifier: "MyHomeViewController") as? MyHomeViewController
        
        navController.viewControllers = [controller]
        
        frostedViewController.contentViewController = navController
    }
    
    @IBAction func profileBtnPressed(_ sender: Any) {
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
    func cancelBtnPressed(_ btn : UIButton ){
        if let navCon = navigationController{
            navCon.popViewController(animated: true)
        }
    }
    func saveBtnPressed(_ btn : UIButton ){
        view.endEditing(true)
        if(nameTextField.text?.isEmpty)!{
            view.makeToast("Please enter name")
            
        } else if(phoneTextField.text?.isEmpty)!{
            view.makeToast("Please enter phone number")
            
        }else if(!(phoneTextField.text?.isLengthValidWithRange(8, 16))!){
            view.makeToast("Please enter valid phone number")
            
        }else if(!(emailTextField.text?.isEmpty)!){
            if(!(emailTextField.text?.isValidEmail())!){
                view.makeToast("Please enter valid email")
            }else{
                if(currentScreen == CurrentScreenType.ADD_SCREEN.rawValue){
                    requestAddContactAPI()
                    
                }else{
                    requestEditContactAPI()
                }
                
            }
        }else{
            
            if(currentScreen == CurrentScreenType.ADD_SCREEN.rawValue){
                requestAddContactAPI()
                
            }else{
                requestEditContactAPI()
            }
        }
        
    }
    func removeBtnPressed(_ btn : UIButton ){
       // requestDeleteContactAPI()
        if let navCon = navigationController{
            navCon.popViewController(animated: true)
        }
    }
    func doneBtnPressed(_ btn : UIButton ){
        view.endEditing(true)
        if(nameTextField.text?.isEmpty)!{
            view.makeToast("Please enter name")
            
        } else if(phoneTextField.text?.isEmpty)!{
            view.makeToast("Please enter phone number")
            
        }else if(!(phoneTextField.text?.isLengthValidWithRange(8, 16))!){
            view.makeToast("Please enter valid phone number")
            
        }else if(!(emailTextField.text?.isEmpty)!){
            if(!(emailTextField.text?.isValidEmail())!){
                view.makeToast("Please enter valid email")
            }else{
                if(currentScreen == CurrentScreenType.ADD_SCREEN.rawValue){
                    requestAddContactAPI()
                    
                }else{
                    requestEditContactAPI()
                }
                
            }
        }else{
            
            if(currentScreen == CurrentScreenType.ADD_SCREEN.rawValue){
                requestAddContactAPI()
                
            }else{
                requestEditContactAPI()
            }
        }
        //requestEditContactAPI()
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
extension AddEditTaskContactViewController{
    func requestAddContactAPI(){
//        var addressText = ""
//        if(addressTextView.text != addressStr){
//            addressText = addressTextView.text
//        }
       
        // {'method_name':'add_user_TaskContact",'task_id':"2",'user_id':'11','name':"pankaj",'phone_number':'454784212477 ','email':'pankaj@gmail.ocm','address':"noida','image':""}
        let userId = UserDefaults.standard.object(forKey: USER_ID) as! String
        let parmDict = ["user_id" : userId ,"method_name" : ApiUrl.METHOD_ADD_TASK_CONTACT  ,"name" : nameTextField.text! , "phone_number" : phoneTextField.text! , "email" : emailTextField.text! , "address" : addressTextView.text , "task_id" : currentTaskID] as [String : Any]
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        ApiManager.sharedInstance.requestApiServer(parmDict, [UIImage](), {(data) ->() in
            MBProgressHUD.hide(for: self.view, animated: true)
            self.responseWithSuccess(data)
            
        }, {(error)-> () in
            print("failure \(error)")
            MBProgressHUD.hide(for: self.view, animated: true)
            self.view.makeToast(NETWORK_ERROR)
            
            
        },{(progress)-> () in
            print("progress \(progress)")
            
        })
        
    }
    func responseWithSuccess(_ userData : Any){
        let dictionary = userData as! NSDictionary
        
        let status = dictionary["status"] as? Int
        let msg = dictionary["msg"] as? String
        if(status == 1){
            SharedAppDelegate.window?.makeToast(msg!)
            self.switchViewController()
        }else{
            
        }
        
    }
    func switchViewController(){
        if(currentScreen == CurrentScreenType.ADD_SCREEN.rawValue){
            if let navCon = navigationController{
                navCon.popViewController(animated: true)
            }
        }else{
            if(fromTask){
            switchToTaskVC()
            }else{
            switchToResourceVC()
            }
        }
       
        delegate?.contactUpdated()
        
    }
    func switchToTaskVC(){
        let allVC = navigationController?.viewControllers
        for vc in allVC! {
            if(vc.isKind(of: TaskContactViewController.self)){
                
                if let navCon = navigationController{
                    navCon.popToViewController(vc, animated: true)
                    let currentVC =  vc as! TaskContactViewController
                    currentVC.requestServer()
                }
                
                break
            }
        }
    }
    func switchToResourceVC(){
        let allVC = navigationController?.viewControllers
        for vc in allVC! {
            if(vc.isKind(of: ResourceContactViewController.self)){
                
                if let navCon = navigationController{
                    navCon.popToViewController(vc, animated: true)
                    let currentVC =  vc as! ResourceContactViewController
                    currentVC.requestServer()
                }
                
                break
            }
        }
    }
}
extension AddEditTaskContactViewController{
    func requestEditContactAPI(){
        let contactID = (model?.id)! as String
//        var addressText = ""
//        if(addressTextView.text != addressStr){
//            addressText = addressTextView.text
//        }
        // {"contact_id":"1",'method_name':'update_user_TaskContact",'name':"pankaj",'phone_number':'454784212477 ','email':'pankaj@gmail.ocm','address':"noida','image':""}

        let userId = UserDefaults.standard.object(forKey: USER_ID) as! String
        let parmDict = ["user_id" : userId ,"method_name" : ApiUrl.METHOD_UPDATE_TASK_CONTACT , "contact_id" : contactID ,"name" : nameTextField.text! , "phone_number" : phoneTextField.text! , "email" : emailTextField.text! , "address" : addressTextView.text ] as [String : Any]
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        ApiManager.sharedInstance.requestApiServer(parmDict, imageArray , {(data) ->() in
            MBProgressHUD.hide(for: self.view, animated: true)
            self.responseWithSuccess(data)
        }, {(error)-> () in
            print("failure \(error)")
            MBProgressHUD.hide(for: self.view, animated: true)
            self.view.makeToast(NETWORK_ERROR)
            
            
        },{(progress)-> () in
            print("progress \(progress)")
            
        })
        
    }
}

extension AddEditTaskContactViewController{
    func requestDeleteContactAPI(){
        let contactID = (model?.id)! as String
       
        // {"method_name":"delete_user_TaskContact","contact_id":"2"}
        
        let userId = UserDefaults.standard.object(forKey: USER_ID) as! String
        let parmDict = ["user_id" : userId ,"method_name" : ApiUrl.METHOD_DELETE_TASK_CONTACT , "contact_id" :contactID] as [String : Any]
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        ApiManager.sharedInstance.requestApiServer(parmDict, [UIImage](), {(data) ->() in
            MBProgressHUD.hide(for: self.view, animated: true)
            self.responseWithSuccess(data)
        }, {(error)-> () in
            print("failure \(error)")
            MBProgressHUD.hide(for: self.view, animated: true)
            self.view.makeToast(NETWORK_ERROR)
            
            
        },{(progress)-> () in
            print("progress \(progress)")
            
        })
        
    }
}

extension AddEditTaskContactViewController : UINavigationControllerDelegate{
    
}

extension AddEditTaskContactViewController : UIImagePickerControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        imageArray.removeAll()
        imagePicker.allowsEditing = true
        imagePicker.dismiss(animated: true, completion: nil)
        profileImageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        imageArray.append((info[UIImagePickerControllerOriginalImage] as? UIImage)!)
    }
    
}

extension AddEditTaskContactViewController : UITextViewDelegate{

    func textViewDidBeginEditing(_ textView: UITextView) {
        
//        if(textView.text == addressStr){
//        textView.text = ""
//        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if(textView.text == ""){
            //textView.text = addressStr
        }
        
    }
}

