//
//  EditNotesViewController.swift
//  MyHomeBuy
//
//  Created by Vikas on 09/11/17.
//  Copyright © 2017 MobileCoderz. All rights reserved.
//

import UIKit
import MBProgressHUD
import Toast_Swift

protocol NotesUpdatedDelegate {
    func notesUpdated()
    
}

class EditNotesViewController: UIViewController {

    @IBOutlet weak var headingHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var headingView: UIView!
    @IBOutlet weak var navigationBarView: UIView!
    
    @IBOutlet weak var headingLbl: UILabel!
    @IBOutlet weak var headingImageView: UIImageView!
    
    @IBOutlet weak var removeBtn: UIButton!
    
    @IBOutlet weak var doneBtn: UIButton!
    
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var subjectTextField: UITextField!
    var fromTask = false
    var currentNotesID = "0"
    var dataDict = NSDictionary()
    var model = NotesModel(dictionary: ["" : ""])
    var delegate : NotesUpdatedDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        frostedViewController.panGestureEnabled = false
//        navigationBarView.setBottomShadow()
//        headingView.setBottomShadow()
        setupData()
        if(fromTask){
            setupHeaderData()
            
        }else{
            headingHeightConstraint.constant = 0
            
        }
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        navigationBarView.setBottomShadow()
        headingView.setBottomShadow()
    }
    func setupData(){
        descriptionTextView.delegate = self
        descriptionTextView.text = model?.description
        subjectTextField.text = model?.subject
        currentNotesID = (model?.id)!
        removeBtn.setRadius(10)
        doneBtn.setRadius(10)

    }
    func setupHeaderData(){
        let image = UIImage.init(named: (dataDict.object(forKey: "image_white") as! String?)!)
        headingImageView.image = image
        let title = dataDict.object(forKey: "headerText") as! String?
        headingLbl.text = title
        
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
    
    @IBAction func homaBtnPressed(_ sender: Any) {
        let navController : UINavigationController  = storyboard?.instantiateViewController(withIdentifier: "SlidingNavigationController") as! UINavigationController
        var controller: UIViewController!
        
        controller = storyboard?.instantiateViewController(withIdentifier: "MyHomeViewController") as? MyHomeViewController
        
        navController.viewControllers = [controller]
        
        frostedViewController.contentViewController = navController
    }

    @IBAction func doneBtnPressed(_ sender: Any) {
        view.endEditing(true)
        if(subjectTextField.text?.isEmpty)!{
            view.makeToast("Please enter subject")
        }else if(descriptionTextView.text.isEmpty){
            view.makeToast("Please enter description")
            
        }else{
            requestEditNotesAPI()
        }
    }
    
    @IBAction func removeBtnPressed(_ sender: Any) {
        view.endEditing(true)
        if let navCon = navigationController{
            navCon.popViewController(animated: true)
        }
       // requestRemoveNotesAPI()
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

extension EditNotesViewController : UITextViewDelegate{
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
//        if(textView.text == descriptionStr){
//            textView.text = ""
//        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if(textView.text == ""){
            //textView.text = descriptionStr
        }
        
    }
}
extension EditNotesViewController{
    func requestEditNotesAPI(){
//         {
//        "method_name":"update_user_TaskNote",
//        "notes_id":"4"
//        "subject":"composer ",
//        "description":"please fill the composers",
//        "date":"2017-07-20"
//    }
   

        
        let userId = UserDefaults.standard.object(forKey: USER_ID) as! String
        let parmDict = ["user_id" : userId ,"method_name" : ApiUrl.METHOD_EDIT_NOTES , "notes_id" : currentNotesID ,"subject" : subjectTextField.text!  , "description" : descriptionTextView.text ] as [String : Any]
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        ApiManager.sharedInstance.requestApiServer(parmDict, [UIImage]() , {(data) ->() in
            MBProgressHUD.hide(for: self.view, animated: true)
            self.responseWithEditAndDelete(data , "edit")
        }, {(error)-> () in
            print("failure \(error)")
            MBProgressHUD.hide(for: self.view, animated: true)
            self.view.makeToast(NETWORK_ERROR)
            
            
        },{(progress)-> () in
            print("progress \(progress)")
            
        })
        
    }
    func responseWithEditAndDelete(_ userData : Any , _ type : String){
        let dictionary = userData as! NSDictionary
        
        let status = dictionary["status"] as? Int
        //let msg = dictionary["msg"] as? String
        if(status == 1){
            if(type == "edit"){
            SharedAppDelegate.window?.makeToast("Notes updated successfully")
            }else{
                SharedAppDelegate.window?.makeToast("Deleted successfully")
            }
            if let navCon = navigationController{
                navCon.popViewController(animated: true)
            }
            delegate?.notesUpdated()
        }else{
            SharedAppDelegate.window?.makeToast("Something went wrong")
        }
    }
}

//extension EditNotesViewController{
//    func requestRemoveNotesAPI(){
//        //{
//           // "method_name":"delete_user_TaskNote",
//            //"notes_id":"4"}
//
//
//
//        let userId = UserDefaults.standard.object(forKey: USER_ID) as! String
//        let parmDict = ["user_id" : userId ,"method_name" : ApiUrl.METHOD_DELETE_NOTES , "notes_id" : currentNotesID  ] as [String : Any]
//
//        MBProgressHUD.showAdded(to: self.view, animated: true)
//        ApiManager.sharedInstance.requestApiServer(parmDict, [UIImage]() , {(data) ->() in
//            MBProgressHUD.hide(for: self.view, animated: true)
//            self.responseWithEditAndDelete(data , "remove")
//        }, {(error)-> () in
//            print("failure \(error)")
//            MBProgressHUD.hide(for: self.view, animated: true)
//            self.view.makeToast(NETWORK_ERROR)
//
//
//        },{(progress)-> () in
//            print("progress \(progress)")
//
//        })
//
//    }
//}


