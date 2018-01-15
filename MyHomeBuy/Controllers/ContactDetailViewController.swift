//
//  ContactDetailViewController.swift
//  MyHomeBuy
//
//  Created by Vikas on 06/11/17.
//  Copyright © 2017 MobileCoderz. All rights reserved.
//

import UIKit
import MessageUI
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
       
       contactNoLbl.text = model?.phone_number
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
