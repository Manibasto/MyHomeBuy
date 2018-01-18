//
//  SettingViewController.swift
//  MyHomeBuy
//
//  Created by Vikas on 23/10/17.
//  Copyright © 2017 MobileCoderz. All rights reserved.
//

import UIKit
import MBProgressHUD
import Toast_Swift
class SettingViewController: UIViewController {
    
    @IBOutlet weak var navigationBarView: UIView!
    var textString = [Any]()

    @IBOutlet weak var settingTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        
        textString = ["","Reset Milestones","My Profile", "Generate Pin"
,"Sign out"]
        settingTableView.delegate = self;
        settingTableView.dataSource = self;
        settingTableView.rowHeight = UITableViewAutomaticDimension
        settingTableView.estimatedRowHeight = 60
        // Do any additional setup after loading the view.
        navigationBarView.setBottomShadow()
        frostedViewController.panGestureEnabled = false
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        var value = ""
        let userPin = UserDefaults.standard.object(forKey: USER_PIN) as! String
        if(userPin == ""){
            value = "Generate Pin"
        }else{
            value = "Change Pin"
            
        }
        textString[3] = value;
        settingTableView.reloadData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func homeBtnPressed(_ sender: Any) {
        refreshHomeMenuUI()
        let navController : UINavigationController  = storyboard?.instantiateViewController(withIdentifier: "SlidingNavigationController") as! UINavigationController
        var controller: UIViewController!
        
        controller = storyboard?.instantiateViewController(withIdentifier: "MyHomeViewController") as? MyHomeViewController
        
        navController.viewControllers = [controller]
        
        frostedViewController.contentViewController = navController
        
    }
    func refreshHomeMenuUI(){
        let vc =  self.frostedViewController.menuViewController as! SideMenuViewController
        vc.currentIndex = 0
        
    }
    @IBAction func backBtnPressed(_ sender: Any) {
        frostedViewController.presentMenuViewController()

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

extension SettingViewController : UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return textString.count;
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.row == 0){
          
            let cell = tableView.dequeueReusableCell(withIdentifier: "HeadingTableCell", for: indexPath) as! HeadingTableCell;
            cell.nameLbl.text = ""
            cell.contactLbl.text = ""
            if let username = UserDefaults.standard.object(forKey: USER_NAME){
                cell.nameLbl.text = username as? String
                
            }
            if let userPhone = UserDefaults.standard.object(forKey: USER_CONTACT_NUMBER){
                cell.contactLbl.text  = userPhone as? String
            }
            cell.customView.setRadius(5)
            return cell
        }
//        else if(indexPath.row == 1){
//            let cell = tableView.dequeueReusableCell(withIdentifier: "HeaderTableCell", for: indexPath) as! HeaderTableCell;
//            cell.headingLbl.text = textString[indexPath.row]
//            
//            return cell
//        }
//        else if(indexPath.row == 2 || indexPath.row == 3){
//            let cell = tableView.dequeueReusableCell(withIdentifier: "SwitchTableCell", for: indexPath) as! SwitchTableCell;
//            cell.switchLbl.text = textString[indexPath.row]
//            cell.switchBtn.addTarget(self, action: #selector(switchTapped(_:)), for: .touchUpInside)
//            cell.switchBtn.tag  = indexPath.row
//            return cell
//            
//        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "OptionsTableCell", for: indexPath) as! OptionsTableCell;
            cell.optionLbl.text = textString[indexPath.row] as? String
           // if(indexPath.row == 1){
            cell.nextImageView.isHidden = true
           // }else{
               // cell.nextImageView.isHidden = false

            //}
            cell.customView.setRadius(5)

            return cell
            
        }
        
        //    private func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        //        let cell = tableView.dequeueReusableCell(withIdentifier: "HeaderTableCell") as! HeaderTableCell
        //        cell.headingLbl.text = "header"
        //        return cell
        //    }
        //
        //    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        //        return ""
        //    }
        
    }
    func switchTapped(_ btn : UIButton){
    btn.isSelected = !btn.isSelected
        btn.setBackgroundImage(btn.isSelected ? UIImage.init(named: "toggle_on") : UIImage.init(named: "toggle_off"), for: .normal)
    }
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if(indexPath.row == 0 ){
//            return 90
//        }else{
//            return 60
//        }
//    }
    
    func showResetAlert(_ title : String , _ msg : String){
        
        let alertController = UIAlertController(title: title, message: msg, preferredStyle: UIAlertControllerStyle.alert)
        
        let destructiveAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: "nil"), style: .default) {
            (result : UIAlertAction) -> Void in
            print("Destructive")
        }

        
        let okAction = UIAlertAction(title: NSLocalizedString("OK", comment: "nil"), style: UIAlertActionStyle.default) {
            (result : UIAlertAction) -> Void in
            print("OK")
           self.requestResetAPI()
}
        
        alertController.addAction(destructiveAction)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
        alertController.view.tintColor = UIColor.black

    }
}
    extension SettingViewController : UITableViewDelegate{
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            switch indexPath.row {
            case 1:
           showResetAlert("MyHomeBuy", NSLocalizedString("Are you sure you want to reset milestones ?", comment: "nil"))
                break
            case 2:
                switchToMyProfileVC()
                break
            case 3:
                if let value = textString[indexPath.row] as? String{
                    if(value == "Generate Pin"){
                        switchToGeneratePinVC()
                    }else{
                      switchToChangePinVC()
                    }
                }

                break
            case 4:
    showAlert(APP_TITLE, "Are you sure you want to exit your profile?")
                break
          
            default:
                break
            }
            
        }
        func switchToChangePinVC(){
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ChangePinViewController") as! ChangePinViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
        func switchToGeneratePinVC(){
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "GeneratePinViewController") as! GeneratePinViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
        func switchToMyProfileVC(){
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MyProfileViewController") as! MyProfileViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        func showAlert(_ title : String , _ msg : String){
            
            let alertController = UIAlertController(title: title, message: msg, preferredStyle: UIAlertControllerStyle.alert)
            
            let DestructiveAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: "nil"), style: .default) {
                (result : UIAlertAction) -> Void in
                print("Destructive")
            }
            
            
            let okAction = UIAlertAction(title: NSLocalizedString("OK", comment: "nil"), style: UIAlertActionStyle.default) {
                (result : UIAlertAction) -> Void in
                print("OK")
                self.clearData()
            }
            
            alertController.addAction(DestructiveAction)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
            alertController.view.tintColor = UIColor.black
            
        }
        
        func clearData(){
            UserDefaults.standard.removeObject(forKey: USER_PIN)
            UserDefaults.standard.removeObject(forKey: USER_IMAGE)
            UserDefaults.standard.removeObject(forKey: USER_NAME)
            UserDefaults.standard.removeObject(forKey: USER_ADDRESS)
            UserDefaults.standard.removeObject(forKey: USER_EMAIL)
            UserDefaults.standard.removeObject(forKey: USER_CONTACT_NUMBER)
            UserDefaults.standard.removeObject(forKey: IS_USER_LOGIN)
            UserDefaults.standard.removeObject(forKey: USER_ID)
            UserDefaults.standard.synchronize()
            var loginAvailable = false
            let viewControllers =  self.navigationController?.viewControllers
            for controller in viewControllers! {
                if controller.isKind(of: LoginViewController.self){
                    if let navCon = self.navigationController{
                        navCon.popToRootViewController(animated: true)
                    }
                    loginAvailable = true
                    break;
                }
            }
            if(!loginAvailable){
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let navigationController:UINavigationController = UINavigationController()
                let rootViewController:UIViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                navigationController.viewControllers = [rootViewController]
                navigationController.isNavigationBarHidden = true
                SharedAppDelegate.window?.rootViewController = navigationController
            }
        }
}

extension SettingViewController{
    func requestResetAPI(){
        //
        
        let userId = UserDefaults.standard.object(forKey: USER_ID) as! String
        let parmDict = ["user_id" : userId ,"method_name" : ApiUrl.METHOD_RESET ] as [String : Any]
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        ApiManager.sharedInstance.requestApiServer(parmDict, [UIImage](), {(data) ->() in
            MBProgressHUD.hide(for: self.view, animated: true)
            self.responseResetSuccess(data)
        }, {(error)-> () in
            print("failure \(error)")
            MBProgressHUD.hide(for: self.view, animated: true)
            self.view.makeToast(NETWORK_ERROR)
            
            
        },{(progress)-> () in
            print("progress \(progress)")
            
        })
        
    }
    
    func responseResetSuccess(_ userData : Any ){
        let dictionary = userData as! NSDictionary
        
        let status = dictionary["status"] as? Int
        //let msg = dictionary["msg"] as? String
        if(status == 1){
            view.makeToast("Reset successfully")

        }else{
            view.makeToast("Milestone can't be reset until you complete your all milestones")
            
        }
       
    }
}
