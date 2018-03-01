//
//  ContactDetailViewController.swift
//  MyHomeBuy
//
//  Created by Vikas on 06/11/17.
//  Copyright © 2017 MobileCoderz. All rights reserved.
//

import UIKit
import MessageUI
import MBProgressHUD
protocol ContactDeleteDelegate {
    func contactDelete()
}
class ContactDetailViewController: UIViewController {
    
    
    
    @IBOutlet weak var contactInPhoneBtn: UIButton!
    @IBOutlet weak var headingHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var profileContainerView: UIView!
    @IBOutlet weak var contactLbl: UILabel!
    @IBOutlet weak var contactImageView: UIImageView!
    @IBOutlet weak var contactHeadingView: UIView!
    @IBOutlet weak var navigationBarView: UIView!
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var initialLbl: UILabel!
    @IBOutlet weak var profileView: UIView!
    
    @IBOutlet weak var nameLbl: UILabel!
    
    @IBOutlet weak var contactNoLbl: UILabel!
    
    @IBOutlet weak var addressLbl: UILabel!
    
    @IBOutlet weak var emailLbl: UILabel!
    var dataDict = NSDictionary()
    var model = AddContactModel(dictionary: ["" : ""])
    var fromTask = false
    var delegate : ContactDeleteDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        frostedViewController.panGestureEnabled = false
        //navigationBarView.setBottomShadow()
       // contactHeadingView.setBottomShadow()
        setupData()
        if(fromTask){
         setupHeaderData()
            setContactBtnVisibility(false)

        }else{
            headingHeightConstraint.constant = 0
            if(model?.status == "1"){
            setContactBtnVisibility(true)
            }else{
                setContactBtnVisibility(false)

            }
        }
         }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        navigationBarView.setBottomShadow()
        contactHeadingView.setBottomShadow()
    }
    func setContactBtnVisibility(_ bool : Bool){
        if(!bool){
        contactInPhoneBtn.setTitle("", for: .normal)
            contactInPhoneBtn.setImage(UIImage.init(named: ""), for: .normal)
        }
    }
    func setupHeaderData(){
        let image = UIImage.init(named: (dataDict.object(forKey: "image_white") as! String?)!)
        contactImageView.image = image
        let title = dataDict.object(forKey: "headerText") as! String?
        contactLbl.text = title
       
    }
    func setupData(){
        contactNoLbl.text = String.phoneNumberFormate(num: (model?.phone_number)!)
        nameLbl.text = model?.name
        emailLbl.text = model?.email
        addressLbl.text = model?.address
        initialLbl.text = model?.name?.getInitials("").uppercased()

        if(model?.image == ""){
        
        }else{
            profileImageView.sd_setImage(with: URL(string: (model?.image)!))
        }
        profileContainerView.setRadius(5)
        profileView.setRadius(profileView.frame.size.width/2)
       
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
    
    @IBAction func deleteButtonPressed(_ sender: Any) {
        showAlert("MyHomeBuy", "Do you really want to delete this contact?")
    }
    func showAlert(_ title : String , _ msg : String ){
        
        let alertController = UIAlertController(title: title, message: msg, preferredStyle: UIAlertControllerStyle.alert)
        
        let DestructiveAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: "nil"), style: .default) {
            (result : UIAlertAction) -> Void in
            print("Destructive")
        }
        
        
        let okAction = UIAlertAction(title: NSLocalizedString("OK", comment: "nil"), style: UIAlertActionStyle.default) {
            (result : UIAlertAction) -> Void in
            self.requestDeleteContactAPI()
            print("OK")
            
        }
        
        alertController.addAction(DestructiveAction)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
        alertController.view.tintColor = UIColor.black
        
    }
    @IBAction func homeBtnPressed(_ sender: Any) {
        let navController : UINavigationController  = storyboard?.instantiateViewController(withIdentifier: "SlidingNavigationController") as! UINavigationController
        var controller: UIViewController!
        
        controller = storyboard?.instantiateViewController(withIdentifier: "MyHomeViewController") as? MyHomeViewController
        
        navController.viewControllers = [controller]
        
        frostedViewController.contentViewController = navController
    }
    
    
    @IBAction func messageBtnPressed(_ sender: Any) {
//         let smsURL = "sms:"
//        
//        guard let url = URL(string: smsURL) else {
//            view.makeToast("Unable to open message")
//            return
//        }
//        openURL(url, "Unable to open message")
        sendMessage()
    }
    
    func sendMessage(){
        if !MFMessageComposeViewController.canSendText() {
            print("SMS services are not available")
             view.makeToast("SMS services are not available")
        }else{
            let composeVC = MFMessageComposeViewController()
            composeVC.messageComposeDelegate = self
            
            // Configure the fields of the interface.
            composeVC.recipients = [contactNoLbl.text!]
            composeVC.body = ""
            
            // Present the view controller modally.
            self.present(composeVC, animated: true, completion: nil)
        }
    }
    @IBAction func callBtnPressed(_ sender: Any) {
        callNumber(contactNoLbl.text!)
    }
    
    private func callNumber(_ phoneNumber:String) {
        let correctPhoneNumber = phoneNumber.replacingOccurrences(of: " ", with: "")
        let phoneCallLink = "tel://\(correctPhoneNumber)"
        guard let url = URL(string: phoneCallLink) else {
            view.makeToast("Unable to make call")
            return
        }
        
        openURL(url, "Unable to make call")
        
    }
    func openURL(_ url : URL , _ errorMsg : String){
        if(UIApplication.shared.canOpenURL(url)){
            if #available(iOS 10.0, *){
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }else{
                UIApplication.shared.openURL(url)
            }
        }else{
            view.makeToast(errorMsg)
        }
        
    }
    func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([emailLbl.text!])
            mail.setMessageBody("<p></p>", isHTML: true)
            
            present(mail, animated: true)
        } else {
            // show failure alert
            view.makeToast("Unable to send Email")

        }
    }
    @IBAction func emailBtnAction(_ sender: Any)
    {
        if(!(emailLbl.text?.isEmpty)!){
        print("emailBtn")
        sendEmail()
    }
    }
    @IBAction func editProfileBtnPressed(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddEditTaskContactViewController") as! AddEditTaskContactViewController
        vc.fromTask = fromTask
        vc.dataDict = dataDict
        vc.currentTaskID = (model?.id)!
        vc.model = model
        vc.currentScreen = AddEditTaskContactViewController.CurrentScreenType.EDIT_SCREEN.rawValue
       // vc.delegate = TaskContactViewController.self
        self.navigationController?.pushViewController(vc, animated: true)
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
extension ContactDetailViewController : MFMessageComposeViewControllerDelegate{
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController,
                                      didFinishWith result: MessageComposeResult) {
        // Check the result or perform other tasks.
        
        // Dismiss the message compose view controller.
        controller.dismiss(animated: true, completion: nil)
    }
}
extension ContactDetailViewController : MFMailComposeViewControllerDelegate{
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)

    }
    
}
extension ContactDetailViewController{
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
    func responseWithSuccess(_ userData : Any){
        let dictionary = userData as! NSDictionary
        
        let status = dictionary["status"] as? Int
        let msg = dictionary["msg"] as? String
        if(status == 1){
         //   self.switchViewController()
            if let navCon = navigationController{
                navCon.popViewController(animated: true)
            }
            delegate?.contactDelete()
        }else{
            
        }
       // SharedAppDelegate.window?.makeToast(msg!)
        
    }
}
