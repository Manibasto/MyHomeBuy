//
//  SignupViewController.swift
//  MyHomeBuy
//
//  Created by Vikas on 04/10/17.
//  Copyright © 2017 MobileCoderz. All rights reserved.
//

import UIKit
import Toast_Swift
import MBProgressHUD
import SwiftyJSON
class SignupViewController: UIViewController {
    
    @IBOutlet weak var signupBtn: UIButton!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        emailTextField.keyboardType = .emailAddress

        signupBtn.setRadius(10)

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        userNameTextField.text = ""
        emailTextField.text  = ""
        passwordTextField.text = ""
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func agreementBtnPressed(_ sender: Any) {
       // view.makeToast("Under Development")
        //openWebView(1)

    }
    
    @IBAction func policyBtnPressed(_ sender: Any) {
        //view.makeToast("Under Development")
        //openWebView(0)

    }
    func openWebView(_ currentIndex : Int){
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WebViewVC") as! WebViewVC
        vc.currentIndex = currentIndex
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func signupBtnPressed(_ sender: Any) {
        if(userNameTextField.text?.isEmpty)!{
            view.makeToast("Please enter name")
        }else if(emailTextField.text?.isEmpty)!{
            view.makeToast("Please enter an email")
        }else if(!(emailTextField.text?.isValidEmail())!){
            view.makeToast("Please enter valid email")
        }else if(passwordTextField.text?.isEmpty)!{
            view.makeToast("Please enter password")
            
        }else{
            requestSignupAPI()
        }
        
    }
    
    
    @IBAction func signinBtnPressed(_ sender: Any) {
        if let navCon = navigationController{
            navCon.popViewController(animated: true)
        }
    }
    
    func requestSignupAPI(){
        let parmDict = ["password" : passwordTextField.text!,"email" : emailTextField.text!,"userName" : userNameTextField.text!,"method_name" : ApiUrl.METHOD_SIGNUP_URL] as [String : Any]
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        ApiManager.sharedInstance.apiCall(parmDict, [UIImage](), {(userJson) ->() in

         self.signWithSuccess(userJson)
            
            
            MBProgressHUD.hide(for: self.view, animated: true)
        }, {(error)-> () in
            print("failure \(error)")
            MBProgressHUD.hide(for: self.view, animated: true)
            self.view.makeToast(NETWORK_ERROR)

            
        },{(progress)-> () in
            print("progress \(progress)")
            
        })
        
    }
    func signWithSuccess(_ userData : Any){
        
        let userDataModel = UserBase(dictionary: userData as! NSDictionary)
        if(userDataModel?.status == 1){
            saveDataToUserDefaults(userDataModel!)
            let signupVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WalkThroughViewController") as! WalkThroughViewController
            self.navigationController?.pushViewController(signupVC, animated: true)
            
            
        }else{
            
            self.view.makeToast("User already exists")
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
        UserDefaults.standard.set("1", forKey: IS_USER_LOGIN)
        UserDefaults.standard.synchronize()
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
