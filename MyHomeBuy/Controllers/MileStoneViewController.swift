//
//  MileStoneViewController.swift
//  MyHomeBuy
//  Created by Vikas on 26/10/17.
//  Copyright © 2017 MobileCoderz. All rights reserved.
//

import UIKit
import MBProgressHUD
import Toast_Swift
class MileStoneViewController: UIViewController {
    var dataArray = [Any]()
    @IBOutlet weak var headingView: UIView!
    var dataModel = MileStoneBase(dictionary: ["" : ""] )
    
    @IBOutlet weak var crossBtn: UIButton!
    @IBOutlet weak var popupCenterView: UIView!
    @IBOutlet var popupView: UIView!
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var mileStoneLbl: UILabel!
    @IBOutlet weak var mileStoneImageView: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var mileStoneTabelView: UITableView!
    @IBOutlet weak var navigationBarView: UIView!
    var currentIndex = -1
    var currentMileStoneNo = 2
    var fakeMileStoneNo = 0
    var additionalInfo = "0"
    //var isMilestoneCompleted = true
    // var setupArray = [Any]()
    @IBOutlet weak var newHomeBtn: UIView!
    @IBOutlet weak var existingHomeBtn: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        crossBtn.setRadius(5)
        mileStoneTabelView.delegate = self
        mileStoneTabelView.dataSource  = self
        mileStoneTabelView.estimatedSectionHeaderHeight = 60
        mileStoneTabelView.sectionHeaderHeight = UITableViewAutomaticDimension
        fakeMileStoneNo = currentMileStoneNo
        setupHeaderData()
        if(currentMileStoneNo == 2){
            dataArray.removeAll()
            popupView.removeFromSuperview()
            currentIndex  = -1
            if(additionalInfo == "1"){
                fakeMileStoneNo = 8
                requestMileStoneAPI()
                
            }else if(additionalInfo == "2"){
                fakeMileStoneNo = 9
                requestMileStoneAPI()
                
            }else{
                createMileStoneDataFor2()
            }
        }

        else{
            requestMileStoneAPI()
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        frostedViewController.panGestureEnabled = false
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        navigationBarView.setBottomShadow()
        headingView.setBottomShadow()
    }
    func setupHeaderData(){
        let mileStoneDataDict = MileStoneData.sharedInstance.getDataDictionary(currentMileStoneNo) as NSDictionary
        let image = UIImage.init(named: (mileStoneDataDict.object(forKey: "image") as! String?)!)
        mileStoneImageView.image = image
        let title = mileStoneDataDict.object(forKey: "text") as! String?
        mileStoneLbl.text = title
        let color = mileStoneDataDict.object(forKey: "colorCode") as! UIColor?
        navigationBarView.backgroundColor = color
        headingView.backgroundColor = color
        titleLbl.text = "Milestone - \(currentMileStoneNo)"
        editBtn.isHidden = true
        
    }
    func initData(){
        dataArray =  MileStoneData.sharedInstance.setupTableData(fakeMileStoneNo)
        mileStoneTabelView.reloadData()
    }
    
    func createMileStoneDataFor2(){
        editBtn.isHidden = false
        popupCenterView.setRadius(5)
        existingHomeBtn.setRadius(5)
        newHomeBtn.setRadius(5)
        popupView.frame = view.frame
        view.addSubview(popupView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func crossBtnAction(_ sender: Any) {
        if let navCon = navigationController{
            navCon.popViewController(animated: true)
        }
    }
    @IBAction func editBtnPressed(_ sender: Any) {
        popupView.frame = view.frame
        view.addSubview(popupView)
    }
    @IBAction func backBtnPressed(_ sender: UIButton) {
        if let navCon = navigationController{
            navCon.popViewController(animated: true)
        }
    }
    
    @IBAction func homeBtnPressed(_ sender: UIButton) {
        let navController : UINavigationController  = storyboard?.instantiateViewController(withIdentifier: "SlidingNavigationController") as! UINavigationController
        var controller: UIViewController!
        
        controller = storyboard?.instantiateViewController(withIdentifier: "MyHomeViewController") as? MyHomeViewController
        
        navController.viewControllers = [controller]
        
        frostedViewController.contentViewController = navController
    }
    
    @IBAction func existingHomeBtnPressed(_ sender: Any) {
        dataArray.removeAll()
        popupView.removeFromSuperview()
        currentIndex  = -1
        fakeMileStoneNo = 8
        additionalInfo = "1"
        requestMileStoneAPI()
    }
    
    @IBAction func newHomeBtnPressed(_ sender: Any) {
        popupView.removeFromSuperview()
        dataArray.removeAll()
        currentIndex  = -1
        fakeMileStoneNo = 9
        additionalInfo = "2"
        requestMileStoneAPI()
    }
    
    
    func requestMileStoneAPI(){
        //{"method_name":"get_milestones_cat","milestone_id":"2","user_id":"11","additional_info":"2"}
        let userId = UserDefaults.standard.object(forKey: USER_ID) as! String
        let parmDict = ["user_id" : userId ,"method_name" : ApiUrl.METHOD_GET_MILESTONE_CATEGORY , "additional_info" : additionalInfo , "milestone_id" : "\(currentMileStoneNo)"] as [String : Any]
        
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
        
        dataModel = MileStoneBase(dictionary: userData as! NSDictionary)
        if(dataModel?.status == 1){
             if(currentMileStoneNo == 2){
            var show = false
            for model in (dataModel?.data)! {
                if(model.status == "0"){
                    show = true
                    break
                }
            }
            editBtn.isHidden = !show
            }
            self.initData()
        }else{
            self.view.makeToast("Unable to fetch data")
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
    
}

extension MileStoneViewController : UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataArray.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(currentIndex == section){
            return 1
        }else{
            return 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MileStoneSelectionTableCell", for: indexPath) as! MileStoneSelectionTableCell;
        cell.tipsBtn.setRadius(7)
        cell.taskBtn.setRadius(7)
        cell.tipsBtn.addTarget(self, action: #selector(tipsTapped( _:)), for: .touchUpInside)
        cell.tipsBtn.tag = indexPath.section
        cell.taskBtn.addTarget(self, action: #selector(taskTapped( _:)), for: .touchUpInside)
        cell.taskBtn.tag = indexPath.section
        let dict = dataArray[indexPath.row] as! NSDictionary
        let colorDark = dict.object(forKey: "colorCodeDark") as! UIColor?
        cell.bgView.backgroundColor = colorDark
        cell.bgView.setRadius(10)
        let color = dict.object(forKey: "colorCode") as! UIColor?
        cell.mileStoneBtn.backgroundColor = color
        cell.mileStoneBtn.setRadius(5)
        cell.mileStoneBtn.tag  = indexPath.section
        cell.mileStoneBtn.addTarget(self, action: #selector(mileStoneBtnTapped(_:)), for: .touchUpInside)
        return cell
    }
    
    func mileStoneBtnTapped(_ btn : UIButton){
//        if(!isEditable){
//            view.makeToast("Cant Edit")
//        }else{
        requestMileStoneCategoryUndoneAPI(btn)
       // }
    }
    func tipsTapped(_ button : UIButton){
        let model = dataModel?.data?[button.tag]
        let tipsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TipsViewController") as! TipsViewController
        tipsVC.currentCategoryId = (model?.id)!
        tipsVC.dataDict = dataArray[button.tag] as! NSDictionary
        self.navigationController?.pushViewController(tipsVC, animated: true)
        
    }
    func taskTapped(_ button : UIButton){
        
        switchToTaskVC(button)
        
    }
    func switchToTaskVC(_ button : UIButton){
        var showTaskList = false
        if(currentMileStoneNo == 2){
            if((fakeMileStoneNo == 8 && button.tag == 0) || (fakeMileStoneNo == 9 && button.tag == 1)){
                showTaskList = true
            }
        }
        let model = dataModel?.data?[button.tag]
        let taskVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TaskViewController") as! TaskViewController
        taskVC.showTaskList = showTaskList
        taskVC.currentCategoryId = (model?.id)!
        taskVC.dataDict = dataArray[button.tag] as! NSDictionary
        taskVC.delegate = self
        taskVC.currentMileStoneNo = currentMileStoneNo
        self.navigationController?.pushViewController(taskVC, animated: true)
        
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let dict = dataArray[section] as! NSDictionary
        let headerText =  dict.object(forKey: "headerText") as! String?
        let imageName =  dict.object(forKey: "image") as! String?
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MileStoneDropDownTableCell") as! MileStoneDropDownTableCell
        cell.customLbl.text = headerText
        cell.customImage.image = UIImage.init(named: imageName!)
        let dropDownImageName =  currentIndex != section ? "dropdown_down" : "dropdown_up"
        cell.dropDownImageView.image = UIImage.init(named: dropDownImageName)
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        cell.addGestureRecognizer(tapRecognizer)
        cell.tag = section
        cell.seperatorView.isHidden = section == dataArray.count-1 ? true : false
        
        return cell
    }
    func handleTap(gestureRecognizer: UIGestureRecognizer)
    {
        
        let tag =   gestureRecognizer.view?.tag
        
        if(currentIndex == tag!){
            currentIndex = -1
        }else{
            currentIndex = tag!
            
        }
        print("tapped section is \(tag!)")
        //        mileStoneTabelView.beginUpdates()
        //        mileStoneTabelView.reloadSections(IndexSet(integersIn: 0...1), with: UITableViewRowAnimation.automatic)
        //mileStoneTabelView.endUpdates()
        
        UIView.transition(with: mileStoneTabelView, duration: 0.5, options: .showHideTransitionViews, animations: {
            self.mileStoneTabelView.reloadData()
            
        }, completion: nil)
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = dataModel?.data?[indexPath.section]
        return model?.status == "0" ? 130 : 208
        //return indexPath.section == 0 ? 208 : 130
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ""
    }
}
extension MileStoneViewController : UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected")
    }
    
}

extension MileStoneViewController{
    func requestMileStoneCategoryUndoneAPI(_ btn : UIButton){
        //{"method_name":"update_milestones_cat","user_id":"11","milestone_id":"1","milestone_cat_id":"1"}
        let model = dataModel?.data?[btn.tag]
        let cat_id = model?.id
        let userId = UserDefaults.standard.object(forKey: USER_ID) as! String
        let parmDict = ["user_id" : userId ,"method_name" : ApiUrl.METHOD_UPDATE_MILESTONE_STATUS ,  "milestone_id" : "\(currentMileStoneNo)" , "milestone_cat_id" : cat_id!] as [String : Any]
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        ApiManager.sharedInstance.requestApiServer(parmDict, [UIImage](), {(data) ->() in
            MBProgressHUD.hide(for: self.view, animated: true)
            self.responseWithUndoneSuccess(data,  btn)
        }, {(error)-> () in
            print("failure \(error)")
            MBProgressHUD.hide(for: self.view, animated: true)
            self.view.makeToast(NETWORK_ERROR)
            
            
        },{(progress)-> () in
            print("progress \(progress)")
        })
        
    }
    
    func responseWithUndoneSuccess(_ userData : Any , _ btn : UIButton){
        let dictionary = userData as! NSDictionary
        
        let status = dictionary["status"] as? Int
        let msg = dictionary["msg"] as? String
        if(status == 1){
            let model = dataModel?.data?[btn.tag]
            if(model?.status == "0"){
                model?.status = "1"
            }else{
                model?.status = "0"
                
            }
            mileStoneTabelView.reloadData()
        }else{
        view.makeToast(msg!)
        }
        //        dataModel = MileStoneBase(dictionary: userData as! NSDictionary)
        //        if(dataModel?.status == 1){
        //            self.initData()
        //        }else{
        //
        //            self.view.makeToast("Unable to fetch data")
        //        }
    }
}

extension MileStoneViewController : TaskCompletedDelegate{
    func taskCompleted() {
        //dataModel?.data?.removeAll()
        //mileStoneTabelView.reloadData()
        requestMileStoneAPI()
    }

}
