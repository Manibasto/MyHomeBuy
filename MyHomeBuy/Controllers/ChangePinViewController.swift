//
//  ChangePinViewController.swift
//  MyHomeBuy
//
//  Created by Vikas on 05/10/17.
//  Copyright © 2017 MobileCoderz. All rights reserved.
//

import UIKit
import SwiftyJSON
import MBProgressHUD
class ChangePinViewController: UIViewController {
    
    @IBOutlet weak var navigationBarView: UIView!
    @IBOutlet weak var oldPinTextField: UITextField!
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var confirmPinTextField: UITextField!
    @IBOutlet weak var newPinTextField: UITextField!
    var currentImage = "back"
    @IBOutlet weak var changeBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        backBtn.setBackgroundImage(UIImage.init(named: currentImage), for: .normal)
        oldPinTextField.keyboardType = .numberPad
        confirmPinTextField.keyboardType = .numberPad
        newPinTextField.keyboardType = .numberPad
        changeBtn.setRadius(10, .lightBlue)
        oldPinTextField.delegate = self
        confirmPinTextField.delegate = self
        newPinTextField.delegate = self
        
        oldPinTextField.setRadius(5)
        confirmPinTextField.setRadius(5)
        newPinTextField.setRadius(5)
        
        oldPinTextField.applyPadding(padding: 5)
        confirmPinTextField.applyPadding(padding: 5)
        newPinTextField.applyPadding(padding: 5)
        navigationBarView.setBottomShadow()

        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        frostedViewController.panGestureEnabled = true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func menuBtnPressed(_ sender: Any) {
        view.endEditing(true)

        if let navCon = navigationController{
            navCon.popViewController(animated: true)
        }
    }
    
    @IBAction func homeButtonTapped(_ sender: Any) {
        let navController : UINavigationController  = storyboard?.instantiateViewController(withIdentifier: "SlidingNavigationController") as! UINavigationController
        var controller: UIViewController!
        
        controller = storyboard?.instantiateViewController(withIdentifier: "MyHomeViewController") as? MyHomeViewController
        
        navController.viewControllers = [controller]
        
        frostedViewController.contentViewController = navController
    }
    
    
    
    @IBAction func changeBtnPressed(_ sender: Any) {
        view.endEditing(true)
        if(oldPinTextField.text?.isEmpty)!{
            view.makeToast("Please Enter Old Pin")

        }else if(!(oldPinTextField.text?.isLengthValid(4))!){
            view.makeToast("Please enter 4 digit old pin number")
        }else if(newPinTextField.text?.isEmpty)!{
            view.makeToast("Please Enter New Pin")
        }else if(!(newPinTextField.text?.isLengthValid(4))!){
            view.makeToast("Please enter 4 digit new pin number")
        }else if(confirmPinTextField.text?.isEmpty)!{
            view.makeToast("Please Enter Confirm Pin")
        }else if(!(confirmPinTextField.text?.isLengthValid(4))!){
            view.makeToast("Please enter 4 digit confirm pin number")
        }else if(!(newPinTextField.text?.isPasswordSame(confirmPinTextField.text!))!){
            view.makeToast("Pin no. and confirm pin no. both should be same")
        }
        else if(oldPinTextField.text == newPinTextField.text){
            view.makeToast("Old pin number and new pin number should not be same")
        }
        
        else{
            requestChangePinAPI()
        }
    }
    func requestChangePinAPI(){
        let userId = UserDefaults.standard.object(forKey: USER_ID) as! String
        let parmDict = ["user_id" : userId , "pin_number" : newPinTextField.text!,"old_pin" : oldPinTextField.text!,"method_name" : ApiUrl.METHOD_CREATE_UPDATE_PIN_URL] as [String : Any]
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        ApiManager.sharedInstance.requestApiServer(parmDict, [UIImage](), {(userJson) ->() in
            let jsondata = JSON(userJson)
            
            print("success  \(userJson)")
            if(jsondata["status"].intValue == 1){
                SharedAppDelegate.window?.makeToast("Pin Changed Successfully")
                UserDefaults.standard.set(self.newPinTextField.text, forKey: USER_PIN)
               
                UserDefaults.standard.synchronize()
                self.backBtn.sendActions(for: .touchUpInside)
            }else{
                
                self.view.makeToast("Unable to Change Pin")
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
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
extension ChangePinViewController : UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let nsString = NSString(string: textField.text!)
        let newText = nsString.replacingCharacters(in: range, with: string)
        return  newText.characters.count <= 4
    }
}
