//
//  LoginViewController.swift
//  MyHomeBuy
//
//  Created by Vikas on 04/10/17.
//  Copyright © 2017 MobileCoderz. All rights reserved.
//

import UIKit
import MBProgressHUD
import SwiftyJSON
class LoginViewController: UIViewController {
    
    @IBOutlet weak var forgotPasswordBtn: UIButton!
    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet weak var forgotMidView: UIView!
    @IBOutlet weak var signinBtn: UIButton!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var forgotPasswordEmailTextField: UITextField!
    
    @IBOutlet var forgotPasswordView: UIView!
    
//    == AvenirNextLTPro-Regular
//    == AvenirNextLTPro-Demi
//    == AvenirNextLTPro-Bold
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        emailTextField.keyboardType = .emailAddress
        setupUI()
        addgesture()
        let str = "Forgot Your Password? Tap here"
        let firstStr = "Forgot Your Password?"
        let secondStr = "Tap here"
        let attrStr = NSMutableAttributedString(string: str)
        let firstFont = UIFont(name: "AvenirNextLTPro-Regular", size: 15)
        let secondFont = UIFont(name: "AvenirNextLTPro-Demi", size: 15)
       
        attrStr.addAttribute(NSForegroundColorAttributeName, value: UIColor.color1, range: (str as NSString).range(of: firstStr))
        attrStr.addAttribute(NSFontAttributeName, value: firstFont!, range: (str as NSString).range(of: firstStr))
        
        attrStr.addAttribute(NSForegroundColorAttributeName, value: UIColor.color2, range: (str as NSString).range(of: secondStr))
        attrStr.addAttribute(NSFontAttributeName, value: secondFont!, range: (str as NSString).range(of: secondStr))
        
        forgotPasswordBtn.setAttributedTitle(attrStr, for: .normal)

       // printFonts()
    }
    func printFonts(){
        for family: String in UIFont.familyNames
        {
            print("\(family)")
            for names: String in UIFont.fontNames(forFamilyName: family)
            {
                print("== \(names)")
            }
        }
    
    }
    func addgesture(){
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(viewTapped( _:)))
        tapGesture.numberOfTapsRequired = 1;
        tapGesture.numberOfTouchesRequired = 1
        tapGesture.delegate = self
        forgotPasswordView.addGestureRecognizer(tapGesture)
    }
    func viewTapped(_ gesture : UITapGestureRecognizer){
        print("hide")
        forgotPasswordView.removeFromSuperview()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        emailTextField.text  = ""
        passwordTextField.text = ""
    }
    func setupUI(){
        forgotMidView.setRadius(5)
        signinBtn.setRadius(10)
        sendBtn.setRadius(10, .lightBlue)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func forgotPasswordBtnPressed(_ sender: Any) {
        forgotPasswordEmailTextField.text = ""
        addView(forgotPasswordView)
        
    }
    
    func addView(_ view:UIView)
    {
        view.translatesAutoresizingMaskIntoConstraints = false
        topView.addSubview(view)
        let views = ["view": view]
        var constraints = [NSLayoutConstraint]()
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[view]-0-|", options: [], metrics: nil, views:views)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[view]-0-|", options: [], metrics: nil, views:views)
        NSLayoutConstraint.activate(constraints)
    }
    
    @IBAction func signupNowBtnPressed(_ sender: Any) {
        let signupVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SignupViewController") as! SignupViewController
        self.navigationController?.pushViewController(signupVC, animated: true)
        
    }
    
    @IBAction func signinBtnPressed(_ sender: Any) {
        view.endEditing(true)
        if(emailTextField.text?.isEmpty)!{
            view.makeToast("Please enter an email")
        }else if(!(emailTextField.text?.isValidEmail())!){
            view.makeToast("Please enter valid email")
        }else if(passwordTextField.text?.isEmpty)!{
            view.makeToast("Please enter password")
            
        }else{
            requestLoginAPI()
        }
    }
    
    @IBAction func sendBtnPressed(_ sender: Any) {
        forgotPasswordEmailTextField.resignFirstResponder()
        
        if(forgotPasswordEmailTextField.text?.isEmpty)!{
            view.makeToast("Please enter an email")
        }else if(!(forgotPasswordEmailTextField.text?.isValidEmail())!){
            view.makeToast("Please enter valid email")
        }else{
            requestForgotPasswordAPI()
        }
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    func requestLoginAPI(){
        let parmDict = ["password" : passwordTextField.text!,"email" : emailTextField.text!,"method_name" : ApiUrl.METHOD_LOGIN_URL] as [String : Any]
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        ApiManager.sharedInstance.requestApiServer(parmDict, [UIImage](), {(data) ->() in
            
            self.loginWithSuccess(data)
            
            MBProgressHUD.hide(for: self.view, animated: true)
        }, {(error)-> () in
            print("failure \(error)")
            MBProgressHUD.hide(for: self.view, animated: true)
            self.view.makeToast(NETWORK_ERROR)
            
            
        },{(progress)-> () in
            print("progress \(progress)")
            
        })
        
    }
    func loginWithSuccess(_ userData : Any){
        
        let jsondata = JSON(userData)
        print("success data  \(jsondata)")
        let userDataModel = UserBase(dictionary: userData as! NSDictionary)
        if(userDataModel?.status == 1){
            saveDataToUserDefaults(userDataModel!)
            let signupVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WalkThroughViewController") as! WalkThroughViewController
            self.navigationController?.pushViewController(signupVC, animated: true)
            
            
        }else{
            
            self.view.makeToast("Wrong email address and password")
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
    func requestForgotPasswordAPI(){
        let parmDict = ["email" : forgotPasswordEmailTextField.text!,"method_name" : ApiUrl.METHOD_FORGOT_PASSWORD_URL] as [String : Any]
        let imageArray = [UIImage]()
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        ApiManager.sharedInstance.requestApiServer(parmDict, imageArray, {(userJson) ->() in
            let jsondata = JSON(userJson)
            
            print("success  \(jsondata)")
            if(jsondata["status"].intValue == 1){
                self.forgotPasswordView.removeFromSuperview()
                self.view.makeToast("Password sent to your Email")
                
            }else{
                
                self.view.makeToast("Email not registered")
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
}
extension LoginViewController : UIGestureRecognizerDelegate{
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        
        
        if(touch.view == forgotMidView){
            return false
        }
        
        return true
    }
}
