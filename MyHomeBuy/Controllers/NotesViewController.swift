//
//  NotesViewController.swift
//  MyHomeBuy
//
//  Created by Vikas on 09/11/17.
//  Copyright © 2017 MobileCoderz. All rights reserved.
//

import UIKit
import MBProgressHUD
import Toast_Swift
class NotesViewController: UIViewController {
    
    @IBOutlet var addNotePopupView: UIView!
    @IBOutlet weak var addNoteBtn: UIButton!
    @IBOutlet var footerView: UIView!
    @IBOutlet weak var headingHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var notesTableView: UITableView!
    @IBOutlet weak var headingLbl: UILabel!
    @IBOutlet weak var headingImageView: UIImageView!
    @IBOutlet weak var navigationBarView: UIView!
    var dataDict = NSDictionary()
    var currentTaskID = "0"
    @IBOutlet weak var headingView: UIView!
    var dataModel = NotesBase(dictionary: ["" : ""] )
    var fromTask = false
    @IBOutlet weak var cancelBtn: UIButton!
    
    @IBOutlet weak var saveBtn: UIButton!
    
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var subjectTextField: UITextField!
    
    @IBOutlet weak var midPopup: UIView!
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
        requestGetAllNotesAPI()
    }
    
    func setupData(){
        
        
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        navigationBarView.setBottomShadow()
        headingView.setBottomShadow()
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
    
    @IBAction func homeBtnPressed(_ sender: Any) {
        let navController : UINavigationController  = storyboard?.instantiateViewController(withIdentifier: "SlidingNavigationController") as! UINavigationController
        var controller: UIViewController!
        
        controller = storyboard?.instantiateViewController(withIdentifier: "MyHomeViewController") as? MyHomeViewController
        
        navController.viewControllers = [controller]
        
        frostedViewController.contentViewController = navController
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

extension NotesViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (dataModel?.data?.count)!
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotesTableCell", for: indexPath) as! NotesTableCell;
        let model = dataModel?.data?[indexPath.row]
        cell.editBtn.addTarget(self, action: #selector(editBtnTapped(_:)), for: .touchUpInside)
        cell.headingLbl.text = model?.subject
        cell.descriptionLbl.text = model?.description
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        let dateStr = model?.created_date
        
        if let date = dateFormatter.date(from: dateStr!){
            dateFormatter.dateFormat = "MMM dd, yyyy"
            let stringDate =  dateFormatter.string(from: date)
           cell.dataLbl.text = stringDate
        }else{
            cell.dataLbl.text = model?.created_date

        }
       
        
        
        if(indexPath.row % 2 == 0){
            cell.contentView.backgroundColor = UIColor.lighterGray
        }else{
            cell.contentView.backgroundColor = UIColor.white
            
        }
        return cell
    }
    
    func editBtnTapped(_ btn : UIButton){
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EditNotesViewController") as! EditNotesViewController
         vc.model = dataModel?.data?[btn.tag]
        vc.fromTask = fromTask
        vc.delegate = self
        vc.dataDict = dataDict
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
}
extension NotesViewController : UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
    
    
}
extension NotesViewController{
    func requestGetAllNotesAPI(){
        //{"method_name":"get_user_TaskNote","user_id":"11", "task_id":"4"}
        
        let userId = UserDefaults.standard.object(forKey: USER_ID) as! String
        let parmDict = ["user_id" : userId ,"method_name" : ApiUrl.METHOD_GET_NOTES , "task_id" : currentTaskID] as [String : Any]
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        ApiManager.sharedInstance.requestApiServer(parmDict, [UIImage](), {(data) ->() in
            MBProgressHUD.hide(for: self.view, animated: true)
            self.responseOfGetAllNotes(data)
        }, {(error)-> () in
            print("failure \(error)")
            MBProgressHUD.hide(for: self.view, animated: true)
            self.view.makeToast(NETWORK_ERROR)
        },{(progress)-> () in
            print("progress \(progress)")
            
        })
        
    }
    func responseOfGetAllNotes(_ userData : Any){
        
        dataModel = NotesBase(dictionary: userData as! NSDictionary)
        if(dataModel?.status == 1){
            notesTableView.delegate = self
            notesTableView.dataSource  = self
            notesTableView.rowHeight = UITableViewAutomaticDimension
            notesTableView.estimatedRowHeight = 50
            notesTableView.reloadData()
        }else{
            
            self.view.makeToast("No notes available")
        }
        addFooterView()
        
    }
    func addFooterView(){
        footerView.frame(forAlignmentRect: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 80))
        notesTableView.tableFooterView = footerView
        let titleColor = addNoteBtn.titleColor(for: .normal)
        addNoteBtn.setRadius(10, titleColor!, 2)
        addNoteBtn.addTarget(self, action: #selector(addNotesBtnTapped), for: .touchUpInside)
        
    }
    
    func saveBtnTapped(){
        view.endEditing(true)
        if(subjectTextField.text?.isEmpty)!{
            view.makeToast("Please enter subject")
        }else if(descriptionTextView.text.isEmpty){
            view.makeToast("Please enter description")
            
        }else{
            requestAddNotesAPI()
        }
    }
    func cancelBtnTapped(){
        addNotePopupView.removeFromSuperview()
        
    }
    func addNotesBtnTapped(){
        addNotePopupView.frame = view.frame
        view.addSubview(addNotePopupView)
        cancelBtn.addTarget(self, action: #selector(cancelBtnTapped), for: .touchUpInside)
        saveBtn.addTarget(self, action: #selector(saveBtnTapped), for: .touchUpInside)
        saveBtn.setRadius(10)
        cancelBtn.setRadius(10)
        midPopup.setRadius(5)
        subjectTextField.text = ""
        descriptionTextView.delegate = self
        subjectTextField.applyPadding(padding: 5)
    
    }
}

extension NotesViewController{
    func requestAddNotesAPI(){
        //{
        // "method_name":"add_user_TaskNote",
        //            "user_id":"11", "task_id":"4",
        //            "subject":"composer ",
        //            "description":"please fill the composers",
        //            "date":"2017-07-20"
        //        }
        
        
//        var descText = ""
//        if(descriptionTextView.text != descriptionStr){
//            descText = descriptionTextView.text
//        }
        let userId = UserDefaults.standard.object(forKey: USER_ID) as! String
        let parmDict = ["user_id" : userId ,"method_name" : ApiUrl.METHOD_ADD_NOTES , "task_id" : currentTaskID , "subject" : subjectTextField.text! , "description" : descriptionTextView.text ] as [String : Any]
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        ApiManager.sharedInstance.requestApiServer(parmDict, [UIImage](), {(data) ->() in
            MBProgressHUD.hide(for: self.view, animated: true)
            self.responseOfAddNotes(data)
        }, {(error)-> () in
            print("failure \(error)")
            MBProgressHUD.hide(for: self.view, animated: true)
            self.view.makeToast(NETWORK_ERROR)
        },{(progress)-> () in
            print("progress \(progress)")
            
        })
        
    }
    func responseOfAddNotes(_ userData : Any){
        
        dataModel = NotesBase(dictionary: userData as! NSDictionary)
        if(dataModel?.status == 1){
            self.view.makeToast("Notes added successfully")
            addNotePopupView.removeFromSuperview()
            requestGetAllNotesAPI()
        }else{
            
            self.view.makeToast("Unable to add notes")
        }
    }
}

extension NotesViewController : UITextViewDelegate{
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
       // if(textView.text == descriptionStr){
            //textView.text = ""
        //}
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if(textView.text == ""){
            //textView.text = descriptionStr
        }
        
    }
}

extension NotesViewController : NotesUpdatedDelegate{
    func notesUpdated() {
        dataModel?.data?.removeAll()
        notesTableView.reloadData()
        requestGetAllNotesAPI()
    }
    
}
