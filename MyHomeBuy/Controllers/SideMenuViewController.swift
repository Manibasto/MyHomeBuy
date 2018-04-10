//
//  SideMenuViewController.swift
//  MyHomeBuy
//
//  Created by Vikas on 05/10/17.
//  Copyright © 2017 MobileCoderz. All rights reserved.
//

import UIKit
import MessageUI


class SideMenuViewController: UIViewController {
    var dataArray = [Any]()
    var currentIndex = 0

    @IBOutlet weak var sideMenuTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        initData()
        sideMenuTableView.delegate = self
        sideMenuTableView.dataSource = self
    }
    func initData(){
        dataArray.removeAll()

        let data1 = ["bg" : "bg_home" , "image" : "home_bg" , "text" : ""]
        let data2 = ["bg" : "bg_profile" , "image" : "settings_SideMenu" , "text" : "Settings"]
        let data3 = ["bg" : "bg_terms" , "image" : "terms" , "text" : "Terms of Use"]
        let data4 = ["bg" : "bg_pin" , "image" : "policy" , "text" : "Privacy Policy"]
        let data5 = ["bg" : "bg_property" , "image" : "contact_SideMenu" , "text" : "Contact Us"]
        let data6 = ["bg" : "bg_exit" , "image" : "rate" , "text" : "Rate this App"]
        dataArray.append(data1)
        dataArray.append(data2)
        dataArray.append(data3)
        dataArray.append(data4)
        dataArray.append(data5)
        dataArray.append(data6)
    }
    func initUI(){
    initData()
        sideMenuTableView.reloadData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func refreshSideMenuVC(with index : Int){
    currentIndex = index
    }
    
    /*
      MARK: - Navigation
     
      In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      Get the new view controller using segue.destinationViewController.
      Pass the selected object to the new view controller.
     }
     */
    func handleSelect(_ indexPath: IndexPath)
    {
        if(currentIndex == indexPath.row){
            frostedViewController.hideMenuViewController()
            
        }else{
            currentIndex = indexPath.row
            var push = true
            let navController : UINavigationController  = storyboard?.instantiateViewController(withIdentifier: "SlidingNavigationController") as! UINavigationController
            
            
            var controller: UIViewController!
            
            switch indexPath.row {
            case 0:
                controller = storyboard?.instantiateViewController(withIdentifier: "MyHomeViewController") as? MyHomeViewController
               
                break
            case 1:
                controller = storyboard?.instantiateViewController(withIdentifier: "SettingViewController") as? SettingViewController
                break
                
            case 2:
                controller = storyboard?.instantiateViewController(withIdentifier: "TermsOfUseViewController") as? TermsOfUseViewController
                break
                
            case 3:
              controller = storyboard?.instantiateViewController(withIdentifier: "WebViewVC") as? WebViewVC
          
                break
                
            case 4:
                push = false
            // view.makeToast("Under Development")
                currentIndex = -1
                sendEmail()
                
                break
                
            case 5:
                push = false
                //view.makeToast("Under Development")
                openAppstoreLink()
                break
                
            default:
                print("nothing")
                
            }
            
            if push {
                navController.viewControllers = [controller]
                
                frostedViewController.contentViewController = navController
                frostedViewController.hideMenuViewController()
            }
        }
    }
    func sendEmail() {
            if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            //mail.setToRecipients = "hyth"
            mail.setToRecipients(["info@myhomebuyapp.com"])
            mail.setMessageBody("<p></p>", isHTML: true)
            
            present(mail, animated: true)
        } else {
            // show failure alert
            view.makeToast("Unable to send Email")
            
        }
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
    func openAppstoreLink(){
        let urlStr = "https://itunes.apple.com/us/app/my-home-buy/id1370295674"
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(URL(string: urlStr)!, options: [:], completionHandler: nil)
            
        } else {
            UIApplication.shared.openURL(URL(string: urlStr)!)
        }
        
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
extension SideMenuViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dict = dataArray[indexPath.row] as! NSDictionary
        
        if(indexPath.row == 0){
            let cell = tableView.dequeueReusableCell(withIdentifier: "SideMenuHeadingTableCell", for: indexPath) as! SideMenuHeadingTableCell
            let bg = dict.object(forKey: "bg") as! String?
            let image = dict.object(forKey: "image") as! String?
            
            // let text = dict.object(forKey: "text") as! String?
            cell.headingBgImageView.image = UIImage.init(named: bg!)
            cell.headingImageView.image = UIImage.init(named: image!)
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "SideMenuOptionTableCell", for: indexPath) as! SideMenuOptionTableCell
            let bg = dict.object(forKey: "bg") as! String?
            let image = dict.object(forKey: "image") as! String?
            
            let text = dict.object(forKey: "text") as! String?
            cell.optionLbl.text  = text
            cell.optionBgImageView.image = UIImage.init(named: bg!)
            cell.optionImageView.image = UIImage.init(named: image!)
            return cell
            
        }
    }
}
extension SideMenuViewController : UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        handleSelect(indexPath)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(view.frame.size.height)/CGFloat(dataArray.count)
    }
}
extension SideMenuViewController : MFMailComposeViewControllerDelegate{
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
        
    }
    
}
