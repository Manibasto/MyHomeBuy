//
//  TaskCheckListViewController.swift
//  MyHomeBuy
//
//  Created by Vikas on 27/10/17.
//  Copyright © 2017 MobileCoderz. All rights reserved.
//

import UIKit
import MBProgressHUD
import Toast_Swift

class TaskCheckListViewController: UIViewController {
    @IBOutlet weak var navigationBarView: UIView!
    @IBOutlet weak var headingView: UIView!
    @IBOutlet var footerView: UIView!
    @IBOutlet weak var taskLbl: UILabel!
    @IBOutlet weak var taskImageView: UIImageView!
    var currentCategoryId = "-1"
    var dataDict = NSDictionary()
    var dataModel = TaskListBase(dictionary: ["" : ""] )
    var isAllListChecked = false
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var taskTableView: UITableView!
    var isEditable = true
    var isReallyEditable = true

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        frostedViewController.panGestureEnabled = false
        //navigationBarView.setBottomShadow()
        //headingView.setBottomShadow()
        setupHeaderData()
        requestCheckListAPI()
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        navigationBarView.setBottomShadow()
        headingView.setBottomShadow()
    }
    func setupHeaderData(){
       // let vc = frostedViewController.menuViewController as! SideMenuViewController
        let image = UIImage.init(named: (dataDict.object(forKey: "image_white") as! String?)!)
        taskImageView.image = image
        let title = dataDict.object(forKey: "headerText") as! String?
       // taskLbl.text = title
        let color = dataDict.object(forKey: "colorCode") as! UIColor?
        navigationBarView.backgroundColor = color
        headingView.backgroundColor = color
        taskLbl.text = title
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
//        if let navCon = navigationController{
//            navCon.popViewController(animated: true)
//        }
        requestSubmitCheckListAPI()
    }

    @IBAction func homeBtnPressed(_ sender: Any) {
        let navController : UINavigationController  = storyboard?.instantiateViewController(withIdentifier: "SlidingNavigationController") as! UINavigationController
        var controller: UIViewController!
        
        controller = storyboard?.instantiateViewController(withIdentifier: "MyHomeViewController") as? MyHomeViewController
        
        navController.viewControllers = [controller]
        
        frostedViewController.contentViewController = navController
    }
    
    @IBAction func submitBtnPressed(_ sender: Any) {
        requestSubmitCheckListAPI()
    }

    func requestSubmitCheckListAPI(){
//        if(!isEditable && !isReallyEditable){
//            view.makeToast("Can't Edit")
//            return
//        }
        var dataAvailableForSubmit = false
        var userDataArray = Array<Dictionary<String,Any>>()
        for model in (dataModel?.data)! {
        let data = ["id" : model.id!  , "status" : model.status!]
            userDataArray.append(data)
            if(model.status == "1"){
            dataAvailableForSubmit = true
            }
        }
        if(!dataAvailableForSubmit){
            
            //view.makeToast("No data to save")
//            if let navCon = navigationController{
//                navCon.popViewController(animated: true)
//            }
//            return
        }
        let userId = UserDefaults.standard.object(forKey: USER_ID) as! String
        let parmDict = ["user_id" : userId ,"method_name" : ApiUrl.METHOD_SUBMIT_CHECK_LIST , "milestone_cat_id" : currentCategoryId , "userdata" : userDataArray] as [String : Any]
        
        //MBProgressHUD.showAdded(to: self.view, animated: true)
        
        ApiManager.sharedInstance.connectToServer(parmDict, {(data) ->() in
          self.responseWithSubmitCheckListSuccess(data)
            
           // MBProgressHUD.hide(for: self.view, animated: true)
            
            
        },
                                                  
                                                  {(error)-> () in
                                                    
                                                    print("failure \(error)")
                                                    self.view.makeToast(NETWORK_ERROR)
                                                    
                                                    //MBProgressHUD.hide(for: self.view, animated: true)
                                                    self.switchViewController()
                                                    
        })
        

        
    }
    
    func responseWithSubmitCheckListSuccess(_ userData : Any){
        let dictionary = userData as! NSDictionary
        
        let status = dictionary["status"] as? Int
        //let msg = dictionary["msg"] as? String
        if(status == 1){
            switchViewController()
            //SharedAppDelegate.window?.makeToast("Submitted successfully")

        }else{
            switchViewController()
        }
        
    }
    func switchViewController(){
            if let navCon = navigationController{
                navCon.popViewController(animated: true)
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
    func requestCheckListAPI(){
      
        let userId = UserDefaults.standard.object(forKey: USER_ID) as! String
       let parmDict = ["user_id" : userId ,"method_name" : ApiUrl.METHOD_GET_CHECK_LIST , "milestone_cat_id" : currentCategoryId] as [String : Any]
        
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
        
        dataModel = TaskListBase(dictionary: userData as! NSDictionary)
        if(dataModel?.status == 1){
            taskTableView.dataSource = self
            taskTableView.delegate  = self
            taskTableView.estimatedRowHeight = 60
            taskTableView.rowHeight = UITableViewAutomaticDimension
            taskTableView.reloadData()
            isReallyEditable = false
            for model in (dataModel?.data)! {
                if(model.status == "0"){
                    isReallyEditable = true
                    break
                }
            }
           // addFooterView()
        }else{
            
            view.makeToast("Unable to fetch data")
        }
    }
    
    func addFooterView(){
        footerView.frame(forAlignmentRect: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 100))
    taskTableView.tableFooterView = footerView
        submitBtn.setRadius(10)
         let color = dataDict.object(forKey: "colorCode") as! UIColor?
        submitBtn.backgroundColor = color
    }
}

extension TaskCheckListViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return (dataModel?.data?.count)!
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = dataModel?.data?[indexPath.row]

        let cell = tableView.dequeueReusableCell(withIdentifier: "CheckListTableCell", for: indexPath) as! CheckListTableCell;
        cell.detailLbl.text = model?.name
        if(model?.status == "0"){
            //cell.checkImageView.image = UIImage.init(named: "suggested_list_uncheck")
            cell.checkBtn.isSelected = false

        }else{
            //cell.checkImageView.image = UIImage.init(named: "suggested_list_check")
            cell.checkBtn.isSelected = true

            
        }
        cell.checkBtn.isUserInteractionEnabled = false
        if(indexPath.row % 2 == 0){
            cell.contentView.backgroundColor = UIColor.lighterGray
        }else{
            cell.contentView.backgroundColor = UIColor.white
            
        }
        return cell
        
        
    }
    
}

extension TaskCheckListViewController : UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(!isEditable && !isReallyEditable){
            view.makeToast("Can't Edit")
        return
        }
        let model = dataModel?.data?[indexPath.row]
        if(model?.status == "0"){
        model?.status = "1"
        }else{
            model?.status = "0"

        }
        let cell = tableView.cellForRow(at: indexPath) as! CheckListTableCell
        cell.checkBtn.isSelected = !cell.checkBtn.isSelected
        
        //cell.che
        //tableView.reloadRows(at: [indexPath], with: .none)
    }

}

