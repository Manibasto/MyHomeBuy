//
//  GeneratePinViewController.swift
//  MyHomeBuy
//
//  Created by Vikas on 05/10/17.
//  Copyright © 2017 MobileCoderz. All rights reserved.
//

import UIKit
import SwiftyJSON
import MBProgressHUD
class GeneratePinViewController: UIViewController {
    var currentImage = "back"

    @IBOutlet weak var navigationBarView: UIView!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var generateBtn: UIButton!
    @IBOutlet weak var repeatPintextField: UITextField!
    @IBOutlet weak var pinTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        backBtn.setBackgroundImage(UIImage.init(named: currentImage), for: .normal)
    pinTextField.keyboardType = .numberPad
    repeatPintextField.keyboardType = .numberPad
        generateBtn.setRadius(10, .lightBlue)
        repeatPintextField.delegate = self
        pinTextField.delegate = self
        pinTextField.setRadius(5)
        repeatPintextField.setRadius(5)
        pinTextField.applyPadding(padding: 5)
        repeatPintextField.applyPadding(padding: 5)
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
    
    
    @IBAction func generateBtnPressed(_ sender: Any) {
        view.endEditing(true)
        if(pinTextField.text?.isEmpty)!{
        view.makeToast("Enter Pin")
        }else if(repeatPintextField.text?.isEmpty)!{
            view.makeToast("Enter Valid Pin")

        }else if(pinTextField.text != repeatPintextField.text){
            view.makeToast("Pin do not match")

        }else if(!(repeatPintextField.text?.isLengthValid(4))!){
            view.makeToast("Enter 4 digit Pin")
            
        }else{
        requestGeneratePinAPI()
        }
    }
    
    func requestGeneratePinAPI(){
        let userId = UserDefaults.standard.object(forKey: USER_ID) as! String
        let parmDict = ["user_id" : userId , "pin_number" : pinTextField.text!,"method_name" : ApiUrl.METHOD_CREATE_UPDATE_PIN_URL] as [String : Any]
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        ApiManager.sharedInstance.requestApiServer(parmDict, [UIImage](), {(userJson) ->() in
            let jsondata = JSON(userJson)
            
            print("success  \(userJson)")
            if(jsondata["status"].intValue == 1){
                SharedAppDelegate.window?.makeToast("Pin Created Successfully")
                UserDefaults.standard.set(self.pinTextField.text, forKey: USER_PIN)
                UserDefaults.standard.synchronize()
              self.backBtn.sendActions(for: .touchUpInside)
            }else{
                
                self.view.makeToast("Unable to generate Pin")
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

extension GeneratePinViewController : UITextFieldDelegate{

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let nsString = NSString(string: textField.text!)
        let newText = nsString.replacingCharacters(in: range, with: string)
        return  newText.characters.count <= 4
    }
}
