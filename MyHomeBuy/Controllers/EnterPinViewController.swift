//
//  EnterPinViewController.swift
//  MyHomeBuy
//
//  Created by Vikas on 04/10/17.
//  Copyright © 2017 MobileCoderz. All rights reserved.
//

import UIKit
import MBProgressHUD
import SwiftyJSON
import SDWebImage
class EnterPinViewController: UIViewController {

    @IBOutlet weak var welcomeLbl: UILabel!
    @IBOutlet weak var forgotPasswordBtn: UIButton!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var forgotPinMidView: UIView!
    @IBOutlet var forgotPinView: UIView!
    @IBOutlet var pinTextFieldArray: [UITextField]!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var submitBtn: UIButton!
   
    @IBOutlet weak var getInBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUI()
        addgesture()
        let str = "Forgot Your Pin Number? Tap here"
        let firstStr = "Forgot Your Pin Number?"
        let secondStr = "Tap here"
        let attrStr = NSMutableAttributedString(string: str)
        let firstFont = UIFont(name: "AvenirNextLTPro-Regular", size: 15)
        let secondFont = UIFont(name: "AvenirNextLTPro-Demi", size: 15)
        
        attrStr.addAttribute(NSForegroundColorAttributeName, value: UIColor.color1, range: (str as NSString).range(of: firstStr))
        attrStr.addAttribute(NSFontAttributeName, value: firstFont!, range: (str as NSString).range(of: firstStr))
        
        attrStr.addAttribute(NSForegroundColorAttributeName, value: UIColor.color2, range: (str as NSString).range(of: secondStr))
        attrStr.addAttribute(NSFontAttributeName, value: secondFont!, range: (str as NSString).range(of: secondStr))
        
        forgotPasswordBtn.setAttributedTitle(attrStr, for: .normal)
    }
    func setupUI(){
        profileImageView.setRadius(5, .lightWhite, 3)

        forgotPinMidView.setRadius(5)
        getInBtn.setRadius(10)
        submitBtn.setRadius(10, .lightBlue)
        for textField in pinTextFieldArray {
            textField.keyboardType = .numberPad
            textField.delegate = self
        }
        if let userImage = UserDefaults.standard.object(forKey: USER_IMAGE){
            let url = userImage as? String
            profileImageView.sd_setImage(with: URL(string: url!), placeholderImage: UIImage(named: "user_icon"))
           
        }
        if let userName = UserDefaults.standard.object(forKey: USER_NAME){
            let name = userName as? String
            welcomeLbl.text = "Welcome \(name!)"
            
        }
    }
    func addgesture(){
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(viewTapped( _:)))
        tapGesture.numberOfTapsRequired = 1;
        tapGesture.numberOfTouchesRequired = 1
        tapGesture.delegate = self
        forgotPinView.addGestureRecognizer(tapGesture)
    }
    func viewTapped(_ gesture : UITapGestureRecognizer){
        print("hide")
        forgotPinView.removeFromSuperview()
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

    @IBAction func submitBtnPressed(_ sender: Any) {
        emailTextField.resignFirstResponder()
        
        if(emailTextField.text?.isEmpty)!{
            view.makeToast("Please enter an email")
        }else if(!(emailTextField.text?.isValidEmail())!){
            view.makeToast("Enter enter an vaild email")
        }else{
            requestForgotPasswordAPI()
        }    }
    @IBAction func getInBtnPressed(_ sender: Any) {
        view.endEditing(true)

       let userPin =  UserDefaults.standard.object(forKey: USER_PIN) as! String
        var pinStr = ""
       
            for (index , field) in pinTextFieldArray .enumerated(){
               let currentField =  UIView.getViewWithTag(pinTextFieldArray, index) as! UITextField
               pinStr =  "\(pinStr)\(currentField.text!)"
            }
        
        print("pin  \(pinStr) andSize \(pinStr.characters.count)")
        if(userPin == pinStr){
            let slidingRootController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SlidingRootViewController") as! SlidingRootViewController
            self.navigationController?.pushViewController(slidingRootController, animated: true)
        }else{
            if(pinStr.isLengthValid(4)){
                self.view.makeToast("Please Enter Correct Pin")
               
            }else{
                self.view.makeToast("Please enter 4 digit Pin no.")

            }
            for textField in self.pinTextFieldArray {
                textField.text = ""
            }
        }
    }
    @IBAction func forgotPinBtnPressed(_ sender: Any) {
        emailTextField.text = ""
        addView(forgotPinView)
    }
    
    func addView(_ view:UIView){
        view.translatesAutoresizingMaskIntoConstraints = false
        topView.addSubview(view)
        let views = ["view": view]
        var constraints = [NSLayoutConstraint]()
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[view]-0-|", options: [], metrics: nil, views:views)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[view]-0-|", options: [], metrics: nil, views:views)
        NSLayoutConstraint.activate(constraints)
    }
    func requestForgotPasswordAPI(){
        let parmDict = ["email" : emailTextField.text!,"method_name" : ApiUrl.METHOD_FORGOT_PIN_URL] as [String : Any]
        let imageArray = [UIImage]()
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        ApiManager.sharedInstance.requestApiServer(parmDict, imageArray, {(userJson) ->() in
            let jsondata = JSON(userJson)

            print("success  \(userJson)")
            if(jsondata["status"].intValue == 1){
                self.forgotPinView.removeFromSuperview()
                self.view.makeToast("Pin sent to your Email")
                
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
extension EnterPinViewController : UIGestureRecognizerDelegate{
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if(touch.view == forgotPinMidView){
            return false
        }
        return true
    }
}

extension EnterPinViewController : UITextFieldDelegate{

    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // type
        if ((textField.text?.characters.count)! < 1  && string.characters.count > 0){
            if(textField == UIView.getViewWithTag(pinTextFieldArray, 0)){
                UIView.getViewWithTag(pinTextFieldArray, 1).becomeFirstResponder()
            }
            if(textField == UIView.getViewWithTag(pinTextFieldArray, 1)){
                UIView.getViewWithTag(pinTextFieldArray, 2).becomeFirstResponder()
            }
            if(textField == UIView.getViewWithTag(pinTextFieldArray, 2)){
                UIView.getViewWithTag(pinTextFieldArray, 3).becomeFirstResponder()
            }
            textField.text = string
            return false
            
        }else if ((textField.text?.characters.count)! >= 1  && string.characters.count == 0){
            //delete
            if(textField == UIView.getViewWithTag(pinTextFieldArray, 1)){
                UIView.getViewWithTag(pinTextFieldArray, 0).becomeFirstResponder()
            }
            if(textField == UIView.getViewWithTag(pinTextFieldArray, 2)){
                UIView.getViewWithTag(pinTextFieldArray, 1).becomeFirstResponder()
            }
            if(textField == UIView.getViewWithTag(pinTextFieldArray, 3)) {
                UIView.getViewWithTag(pinTextFieldArray, 2).becomeFirstResponder()
            }
            textField.text = ""
            return false
        }else if ((textField.text?.characters.count)! >= 1  ){
            textField.text = string
            return false
        }
        return true
    }

    

}
