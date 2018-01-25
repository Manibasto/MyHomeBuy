//
//  TaskViewController.swift
//  MyHomeBuy
//
//  Created by Vikas on 27/10/17.
//  Copyright © 2017 MobileCoderz. All rights reserved.
//

import UIKit
import MBProgressHUD
import Toast_Swift
import KMPlaceholderTextView
protocol TaskCompletedDelegate {
    func taskCompleted()
}
class TaskViewController: UIViewController {
    @IBOutlet weak var taskLbl: UILabel!
    @IBOutlet weak var taskImageView: UIImageView!
    @IBOutlet weak var taskHeadingView: UIView!
    @IBOutlet weak var navigationBarView: UIView!
    @IBOutlet weak var taskTableView: UITableView!
    var currentCategoryId = "-1"
    var dataDict = NSDictionary()
    var dataModel = TaskBase(dictionary: ["" : ""] )
    var currentMileStoneNo = -1
    @IBOutlet var footerView: UIView!
    var showTaskList = false
    @IBOutlet weak var checkListBtn: UIButton!
    var currentIndex = -1
    var delegate : TaskCompletedDelegate?
    // add task outlets
    var canReload = false
    @IBOutlet weak var addTaskTextView: UITextView!
    @IBOutlet weak var remainingTextLbl: UILabel!
    @IBOutlet var addTaskPopupView: UIView!
    
    @IBOutlet weak var addTaskMidView: UIView!
   
    @IBOutlet weak var addNewTaskLbl: UILabel!
    
    @IBOutlet weak var addTaskCancelBtn: UIButton!
    
    @IBOutlet weak var addTaskCreateBtn: UIButton!
    var valueFirst : Float?
    var valueSecond : Float?
    var valueThird : Float?
    var valueFourth : Float?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        frostedViewController.panGestureEnabled = false
        //navigationBarView.setBottomShadow()
        //taskHeadingView.setBottomShadow()
        setupHeaderData()
        requestTaskAPI()
        
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        navigationBarView.setBottomShadow()
        taskHeadingView.setBottomShadow()
    }
    func setupHeaderData(){
        let image = UIImage.init(named: (dataDict.object(forKey: "image_white") as! String?)!)
        taskImageView.image = image
        let title = dataDict.object(forKey: "headerText") as! String?
        taskLbl.text = title
        let color = dataDict.object(forKey: "colorCode") as! UIColor?
        navigationBarView.backgroundColor = color
        taskHeadingView.backgroundColor = color

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func requestTaskAPI(){
        //{"method_name":"get_tasks","milestone_cat_id":"1","user_id":"11"}
        
        
        let userId = UserDefaults.standard.object(forKey: USER_ID) as! String
        let parmDict = ["user_id" : userId ,"method_name" : ApiUrl.METHOD_GET_TASK , "milestone_cat_id" : currentCategoryId] as [String : Any]
        
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
        
        dataModel = TaskBase(dictionary: userData as! NSDictionary)
        if(dataModel?.status == 1){
            taskTableView.dataSource = self
            taskTableView.estimatedRowHeight = 239
            taskTableView.rowHeight = UITableViewAutomaticDimension
            taskTableView.reloadData()
            if(showTaskList){
                //self.addFooterView()
            }
          
        }else{
            
            self.view.makeToast("Unable to fetch data")
        }
    }
   
    func addFooterView(){
        footerView.frame(forAlignmentRect: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 80))
        taskTableView.tableFooterView = footerView
        let color = dataDict.object(forKey: "colorCode") as! UIColor?
        checkListBtn.setRadius(10, color!, 2)
       checkListBtn.setTitleColor(color, for: .normal)
    }
    
    func checkListButtonAction(_ button : UIButton){
        
        switchToTaskListVC(button)

        
    }
    @IBAction func checkListBtnPressed(_ sender: Any) {
      
        switchToTaskListVC(sender as! UIButton)
        
    }
    
    func switchToTaskListVC(_ button : UIButton){
        let model = dataModel?.data?[0]
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TaskCheckListViewController") as! TaskCheckListViewController
        vc.currentCategoryId = (model?.milestone_cat_id)!
        vc.dataDict = dataDict
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    @IBAction func backBtnPressed(_ sender: Any) {
        if(canReload){
            delegate?.taskCompleted()
        }
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
extension TaskViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return (dataModel?.data?.count)!
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(currentCategoryId == "3" || currentCategoryId == "5"){
            let model = dataModel?.data?[indexPath.row]
            let color = dataDict.object(forKey: "colorCode") as! UIColor?

            if(indexPath.row != (dataModel?.data?.count)!-1){
                let cell = tableView.dequeueReusableCell(withIdentifier: "TaskTableCell", for: indexPath) as! TaskTableCell;
                underlineText(of: cell, for: indexPath)
                //cell.taskLbl.text = model?.name
                if(model?.status == "0"){
                    cell.mileStoneStatusBtn.setTitleColor(UIColor.black, for: .normal)
                    cell.mileStoneStatusBtn.setTitle("Milestone task is incomplete" , for: .normal)
                    cell.mileStoneStatusBtn.setImage(UIImage.init(named: ""), for: .normal)
                    cell.taskCompleteBtn.setTitle("Mark as Task Complete", for: .normal)
                    
                }else{
                    cell.mileStoneStatusBtn.setTitleColor(color
                        , for: .normal)
                    cell.mileStoneStatusBtn.setTitle("  Milestone Task Done" , for: .normal)
                    let image = UIImage.init(named: (dataDict.object(forKey: "complete") as! String?)!)
                    cell.mileStoneStatusBtn.setImage(image, for: .normal)
                    cell.taskCompleteBtn.setTitle("Undo Task Complete", for: .normal)
                }
                cell.taskCompleteBtn.tag = indexPath.row
                cell.taskCompleteBtn.addTarget(self, action: #selector(taskCompletedBtnPapped(_:)), for: .touchUpInside)
                //             cell.taskCompleteBtn.backgroundColor = color
                //             cell.taskCompleteBtn.setRadius(10)
                cell.taskCompleteBtn.setRadius(10, color!, 2)
                cell.taskCompleteBtn.setTitleColor(color, for: .normal)
                for btn in cell.btnArray {
                    btn.addTarget(self, action: #selector(btnTapped(_:)), for: .touchUpInside)
                }
                changeBackgoundColor(of: cell, with: indexPath)

//                if(indexPath.row % 2 == 0){
//                    cell.contentView.backgroundColor = UIColor.lighterGray
//                }else{
//                    cell.contentView.backgroundColor = UIColor.white
//
//                }
                return cell
            }else{
            //let color = dataDict.object(forKey: "colorCode") as! UIColor?
            let cell = tableView.dequeueReusableCell(withIdentifier: "TaskSuggestionListTableCell", for: indexPath) as! TaskSuggestionListTableCell;
            cell.taskLbl.text = model?.name
            if(model?.status == "0"){
                cell.mileStoneStatusBtn.setTitleColor(UIColor.black, for: .normal)
                cell.mileStoneStatusBtn.setTitle("Milestone task is incomplete" , for: .normal)
                cell.mileStoneStatusBtn.setImage(UIImage.init(named: ""), for: .normal)
                cell.taskCompleteBtn.setTitle("Mark as Task Complete", for: .normal)
                
            }else{
                cell.mileStoneStatusBtn.setTitleColor(color
                    , for: .normal)
                cell.mileStoneStatusBtn.setTitle("  Milestone Task Done" , for: .normal)
                let image = UIImage.init(named: (dataDict.object(forKey: "complete") as! String?)!)
                cell.mileStoneStatusBtn.setImage(image, for: .normal)
                cell.taskCompleteBtn.setTitle("Undo Task Complete", for: .normal)
            }
            cell.taskCompleteBtn.tag = indexPath.row
            cell.taskCompleteBtn.addTarget(self, action: #selector(taskCompletedBtnPapped(_:)), for: .touchUpInside)
            //             cell.taskCompleteBtn.backgroundColor = color
            //             cell.taskCompleteBtn.setRadius(10)
            cell.taskCompleteBtn.setRadius(10, color!, 2)
            cell.taskCompleteBtn.setTitleColor(color, for: .normal)
            for btn in cell.btnArray {
                btn.addTarget(self, action: #selector(btnTapped(_:)), for: .touchUpInside)
            }
                changeBackgoundColor(of: cell, with: indexPath)

//            if(indexPath.row % 2 == 0){
//                cell.contentView.backgroundColor = UIColor.lighterGray
//            }else{
//                cell.contentView.backgroundColor = UIColor.white
//
//            }
                cell.suggestionCheckListButton.setRadius(10, color!, 2)
                cell.suggestionCheckListButton.setTitleColor(color, for: .normal)
           cell.suggestionCheckListButton.addTarget(self, action: #selector(checkListButtonAction(_:)), for: .touchUpInside)
                return cell
            }
        }else{
            
            let model = dataModel?.data?[indexPath.row]
            let color = dataDict.object(forKey: "colorCode") as! UIColor?
            if(model?.calculation == "1"){
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCalculationTableCell", for: indexPath) as! TaskCalculationTableCell;
                cell.taskLbl.text = model?.name
                cell.resultButton.setTitle("", for: .normal)
                if(model?.status == "0"){
                    cell.mileStoneStatusBtn.setTitleColor(UIColor.black, for: .normal)
                    cell.mileStoneStatusBtn.setTitle("Milestone task is incomplete" , for: .normal)
                    cell.mileStoneStatusBtn.setImage(UIImage.init(named: ""), for: .normal)
                    cell.taskCompleteBtn.setTitle("Mark as Task Complete", for: .normal)
                    setupCellDataForUndone(indexPath, cell, model!)
                    
                }else{
                    cell.mileStoneStatusBtn.setTitleColor(color
                        , for: .normal)
                    cell.mileStoneStatusBtn.setTitle("  Milestone Task Done" , for: .normal)
                    let image = UIImage.init(named: (dataDict.object(forKey: "complete") as! String?)!)
                    cell.mileStoneStatusBtn.setImage(image, for: .normal)
                    cell.taskCompleteBtn.setTitle("Undo Task Complete", for: .normal)
                    setupCellDataForDone(indexPath, cell, model!)
                }
                
                cell.taskCompleteBtn.tag = indexPath.row
                cell.taskCompleteBtn.addTarget(self, action: #selector(taskCompletedBtnPapped(_:)), for: .touchUpInside)
                //cell.taskCompleteBtn.backgroundColor = color
                //cell.taskCompleteBtn.setRadius(10)
                cell.taskCompleteBtn.setRadius(10, color!, 2)
                cell.taskCompleteBtn.setTitleColor(color, for: .normal)
                cell.resultView.setRadius(5)
                for btn in cell.btnArray {
                    btn.addTarget(self, action: #selector(btnTapped(_:)), for: .touchUpInside)
                }
               // cell.contentView.backgroundColor = UIColor.lighterGray
                changeBackgoundColor(of: cell, with: indexPath)

                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "TaskTableCell", for: indexPath) as! TaskTableCell;
                underlineText(of: cell, for: indexPath)
                //cell.taskLbl.text = model?.name
                if(model?.status == "0"){
                    cell.mileStoneStatusBtn.setTitleColor(UIColor.black, for: .normal)
                    cell.mileStoneStatusBtn.setTitle("Milestone task is incomplete" , for: .normal)
                    cell.mileStoneStatusBtn.setImage(UIImage.init(named: ""), for: .normal)
                    cell.taskCompleteBtn.setTitle("Mark as Task Complete", for: .normal)
                    
                }else{
                    cell.mileStoneStatusBtn.setTitleColor(color
                        , for: .normal)
                    cell.mileStoneStatusBtn.setTitle("  Milestone Task Done" , for: .normal)
                    let image = UIImage.init(named: (dataDict.object(forKey: "complete") as! String?)!)
                    cell.mileStoneStatusBtn.setImage(image, for: .normal)
                    cell.taskCompleteBtn.setTitle("Undo Task Complete", for: .normal)
                }
                cell.taskCompleteBtn.tag = indexPath.row
                cell.taskCompleteBtn.addTarget(self, action: #selector(taskCompletedBtnPapped(_:)), for: .touchUpInside)
                //             cell.taskCompleteBtn.backgroundColor = color
                //             cell.taskCompleteBtn.setRadius(10)
                cell.taskCompleteBtn.setRadius(10, color!, 2)
                cell.taskCompleteBtn.setTitleColor(color, for: .normal)
                for btn in cell.btnArray {
                    btn.addTarget(self, action: #selector(btnTapped(_:)), for: .touchUpInside)
                }
                changeBackgoundColor(of: cell, with: indexPath)
//                if(indexPath.row % 2 == 0){
//                    cell.contentView.backgroundColor = UIColor.lighterGray
//                }else{
//                    cell.contentView.backgroundColor = UIColor.white
//
//                }
                return cell
            }
        }
        
        
    }
    func underlineText(of cell : TaskTableCell , for indexPath : IndexPath){
        let model = dataModel?.data?[indexPath.row]
        if(model?.milestone_cat_id == "12" && indexPath.row == 1){
            let attributedString = NSAttributedString(string: (model?.name)!)
            let textRange = NSMakeRange(0, 6)
            let underlinedMessage = NSMutableAttributedString(attributedString: attributedString)
            underlinedMessage.addAttribute(NSUnderlineStyleAttributeName, value: NSUnderlineStyle.styleSingle.rawValue,
                                           range: textRange)
            cell.taskLbl.attributedText = underlinedMessage
            //cell.taskLbl.attributedText = NSAttributedString.init(string: (model?.name)!)
            
        }else{
            cell.taskLbl.attributedText = NSAttributedString.init(string: (model?.name)!)
        }
        
    }
    func changeBackgoundColor(of cell : UITableViewCell , with indexPath : IndexPath){
        if(indexPath.row % 2 == 0){
            cell.contentView.backgroundColor = UIColor.lighterGray
        }else{
            cell.contentView.backgroundColor = UIColor.white
            
        }
    }
    func setupCellDataForDone(_ indexPath : IndexPath , _ cell : TaskCalculationTableCell , _ model : TaskData){
        cell.resultLbl.text = "My maximum purchase price\nTotal\n$ 0.0"
        
        let value = model.value
        let valueList = value?.components(separatedBy: ",")
        var hasValue = false
        if(valueList?.count == 4){
            hasValue = true
            let first = Float((valueList?[0])!)
            let second = Float((valueList?[1])!)
            let third = Float((valueList?[2])!)
            let fourth = Float((valueList?[3])!)
            if let firstvalue = first , let secondvalue = second , let thirdValue = third , let fourthValue = fourth{
                let result = firstvalue + secondvalue + thirdValue - fourthValue
      cell.resultLbl.text = "My maximum purchase price\nTotal\n$ \(result)"
            }
            
            
           
            
        }
        for (index , textField) in cell.amountTextFieldArray.enumerated() {
            textField.isUserInteractionEnabled = false
            textField.setRadius(5)
            textField.setLeftLabel("$", .red)
            textField.backgroundColor = UIColor.white
            if(hasValue){
                let currentField = UIView.getViewWithTag(cell.amountTextFieldArray, textField.tag) as! UITextField
                //if(valueList?[index] != "0"){
                    currentField.text = valueList?[index]
                //}
            }
        }
        

    
    }
    
    func setupCellDataForUndone(_ indexPath : IndexPath , _ cell : TaskCalculationTableCell , _ model : TaskData){
        cell.resultLbl.text = "My maximum purchase price\nTotal\n$ 0.0"
      for (index , textField) in cell.amountTextFieldArray.enumerated() {
            textField.delegate = self
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)),
                                       for: UIControlEvents.editingChanged)
            textField.keyboardType = .decimalPad
            textField.setRadius(5)
            textField.setLeftLabel("$", .red)
            textField.backgroundColor = UIColor.white
                let currentField = UIView.getViewWithTag(cell.amountTextFieldArray, textField.tag) as! UITextField
//            switch index {
//            case 0:
//                currentField.text = valueFirst
//                break
//            case 1:
//                currentField.text = valueSecond
//
//                break
//            case 2:
//                currentField.text = valueThird
//
//                break
//            case 3:
//                currentField.text = valueFourth
//
//                break
//            default:
//                break
//            }

            }

//        if(!valueFirst.isEmpty && !valueSecond.isEmpty && !valueThird.isEmpty && !valueFourth.isEmpty){
//            let first = Float(valueFirst)
//            let second = Float(valueSecond)
//            let third = Float(valueThird)
//            let fourth = Float(valueFourth)
//            if let firstvalue = first , let secondvalue = second , let thirdValue = third , let fourthValue = fourth{
//                let result = firstvalue + secondvalue + thirdValue - fourthValue
//                if(result < 0){
//                }else{
//                    cell.resultLbl.text = "My maximum purchase price\nTotal\n$ \(result)"
//
//
//                }
//
//            }else{
//                //view.makeToast("Invalid value entered")
//
//            }
//
//        }
        }
        
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let nsString = NSString(string: textField.text!)
        let newText = nsString.replacingCharacters(in: range, with: string)
        if(!newText.isEmpty){
        let value = Float(newText)
        guard let validValue = value else{return false}
        print(validValue)
        }
        return true
    }
    func textFieldDidChange(_ textField: UITextField) {
        print("textFieldDidChange  \(textField.text!)")
        switch textField.tag {
        case 0:
            if let value = textField.text{
                if(!value.isEmpty){
                    let floatValue = Float(value)
                    if let validFloatValue = floatValue{
                        valueFirst = validFloatValue
                    }
                }else{
                    valueFirst = nil
                }
            }
            break
        case 1:
            if let value = textField.text{
                if(!value.isEmpty){
                    let floatValue = Float(value)
                    if let validFloatValue = floatValue{
                        valueSecond = validFloatValue
                    }
                }else{
                    valueSecond = nil
                }
            }
            break
        case 2:
            if let value = textField.text{
                if(!value.isEmpty){
                    let floatValue = Float(value)
                    if let validFloatValue = floatValue{
                        valueThird = validFloatValue
                    }
                }else{
                    valueThird = nil
                }
            }
            break
        case 3:
            if let value = textField.text{
                if(!value.isEmpty){
                    let floatValue = Float(value)
                    if let validFloatValue = floatValue{
                        valueFourth = validFloatValue
                    }
                }else{
                    valueFourth = nil
                }
            }
            break
        default:
            break
        }
        
        let cell = getCellForView(view: textField) as? TaskCalculationTableCell
        if let calculationCell = cell{
            calculationCell.resultLbl.text = "My maximum purchase price\nTotal\n$ \(getTotal())"

            
        }
    
        
        
    }
    func getTotal()->Float{
        let first = valueFirst ?? 0
        let second = valueSecond ?? 0
        let third = valueThird ?? 0
        let fourth = valueFourth ?? 0
        let total = first + second + third - fourth
        print("total \(total)")
        return total
    }
    func getStringValue()->String{
        var firstString = "0"
        var secondString = "0"
        var thirdString = "0"
        var fourthString = "0"
        if let first = valueFirst{
            firstString = "\(first)"
        }
        if let second = valueSecond{
            secondString = "\(second)"
        }
        if let third = valueThird{
            thirdString = "\(third)"
        }
        if let fourth = valueFourth{
            fourthString = "\(fourth)"
        }
     
        let fullValue = "\(firstString),\(secondString),\(thirdString),\(fourthString)"
        print("fullValue \(fullValue)")
        return fullValue
    }
    func taskCompletedBtnPapped(_ btn : UIButton ){
        view.endEditing(true)
        currentIndex = btn.tag
        let model = dataModel?.data?[btn.tag]
        let taskId = model?.id
        var status = "0"
        if(model?.status == "0"){
            status = "1"
        }
        
        if(model?.calculation == "1"){
            if(model?.status == "0"){
                if(getTotal() < 0){
                    view.makeToast("Result cannot be negative")
                }
            }else{
                requestSetTaskStatusAPI(taskId!, status)
                
            }
            
        }else{
            requestSetTaskStatusAPI(taskId!, status)
            
        }
        
        
    }
    func btnTapped(_ btn : UIButton ){
        let cell = getCellForView(view: btn)
        
        let indexPath = taskTableView.indexPath(for: cell!)
        print("UIButton row is \((indexPath?.row)!)  section is \((indexPath?.section)!) with btnTag \(btn.tag)")
        switch btn.tag {
        case 0:
            switchToContacts(indexPath!)
            break
        case 1:
            switchToNotes(indexPath!)
            break
        case 2:
            switchToCalender(indexPath!)
            break
        case 3:
            switchToDocuments(indexPath!)
            break
        case 4:
            switchToAddTask(indexPath!)
            break
        default:
            view.makeToast("Something went wrong")
            break
        }
    }
    func switchToDocuments(_ indexPath : IndexPath){
        let model = dataModel?.data?[indexPath.row]
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DocumentsViewController") as! DocumentsViewController
    //vc.currentCategoryId = (model?.milestone_cat_id)!
        vc.dataDict = dataDict
        vc.currentTaskID = (model?.id)!
        vc.fromTask = true

        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func switchToContacts(_ indexPath : IndexPath){
        let model = dataModel?.data?[indexPath.row]
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TaskContactViewController") as! TaskContactViewController
        //vc.currentCategoryId = (model?.milestone_cat_id)!
        vc.dataDict = dataDict
        vc.currentTaskID = (model?.id)!
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    func switchToNotes(_ indexPath : IndexPath){
        let model = dataModel?.data?[indexPath.row]
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NotesViewController") as! NotesViewController
        //vc.currentCategoryId = (model?.milestone_cat_id)!
        vc.dataDict = dataDict
        vc.currentTaskID = (model?.id)!
        vc.fromTask = true
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    func switchToCalender(_ indexPath : IndexPath){
        let model = dataModel?.data?[indexPath.row]
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CalenderViewController") as! CalenderViewController
        //vc.currentCategoryId = (model?.milestone_cat_id)!
        vc.dataDict = dataDict
        vc.currentTaskID = (model?.id)!
        vc.fromTask = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func switchToAddTask(_ indexPath : IndexPath){
       // if(isEditable){
            setupAddPopupView()

//        }else{
//        showErrorMsg()
//        }
        
    }
    func showErrorMsg(){
        view.makeToast("Can't edit")

    }
    func setupAddPopupView(){
        addTaskPopupView.frame = view.frame
        view.addSubview(addTaskPopupView)
        let color = dataDict.object(forKey: "colorCode") as! UIColor?
        addNewTaskLbl.textColor = color
        addTaskCancelBtn.addTarget(self, action: #selector(cancelBtnTapped), for: .touchUpInside)
         addTaskCreateBtn.addTarget(self, action: #selector(createBtnTapped), for: .touchUpInside)
        addTaskCreateBtn.backgroundColor = color
        addTaskMidView.setRadius(5)
        addTaskCreateBtn.setRadius(10)
        addTaskCancelBtn.setRadius(10)
        remainingTextLbl.text = ""
        addTaskTextView.text = ""
        
    }
    
    func cancelBtnTapped(){
       
    addTaskPopupView.removeFromSuperview()
    }
    
    func createBtnTapped(){
        if(!addTaskTextView.text.isEmpty){
            requestAddTaskAPI()
        }else{
            view.makeToast("Please enter task description")
        }
        
    }
    func getCellForView(view:UIView) -> UITableViewCell?
    {
        var superView = view.superview
        
        while superView != nil
        {
            if superView is UITableViewCell
            {
                return superView as? UITableViewCell
            }
            else
            {
                superView = superView?.superview
            }
        }
        
        return nil
    }
}

extension TaskViewController : UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
      //  print("textFieldDidEndEditing  \(textField.text)")
//        switch textField.tag {
//        case 0:
//            valueFirst = textField.text!
//            break
//        case 1:
//            valueSecond = textField.text!
//
//            break
//        case 2:
//            valueThird = textField.text!
//
//            break
//        case 3:
//            valueFourth = textField.text!
//
//
//            break
//        default:
//            break
//        }
//        if(!valueFirst.isEmpty && !valueSecond.isEmpty && !valueThird.isEmpty && !valueFourth.isEmpty){
//            let first = Float(valueFirst)
//            let second = Float(valueSecond)
//            let third = Float(valueThird)
//            let fourth = Float(valueFourth)
//            if let firstvalue = first , let secondvalue = second , let thirdValue = third , let fourthValue = fourth{
//                let result = firstvalue + secondvalue + thirdValue - fourthValue
//                let cell = getCellForView(view: textField) as! TaskCalculationTableCell
//                if(result < 0){
//                    view.makeToast("Result cannot be negative")
//                }else{
//                    cell.resultLbl.text = "My maximum purchase price\nTotal\n$ \(result)"
//                    if let indexPath = taskTableView.indexPath(for: cell){
//                        taskTableView.reloadRows(at: [indexPath], with: .automatic)
//                    }
//
//                }
//
//            }else{
//                view.makeToast("Invalid value entered")
//
//            }
//
//        }else{
//            //         let cell = getCellForView(view: textField) as! TaskCalculationTableCell
//            //            if let indexPath = taskTableView.indexPath(for: cell){
//            //            taskTableView.reloadRows(at: [indexPath], with: .automatic)
//            //            }
//        }
    }

}
extension TaskViewController{

    func requestSetTaskStatusAPI(_ taskID : String , _ status : String){
//         {
//        "method_name":"add_tasks",
//        "user_id":"11",
//        "task_id":"2",
//        "milestone_cat_id":"1 ",
//        "status":"1","amount_1":"10","amount_2":"20","amount_3":"100","amount_4":"100"
//    }

        
        var firstString = "0"
        var secondString = "0"
        var thirdString = "0"
        var fourthString = "0"
        if let first = valueFirst{
            firstString = "\(first)"
        }
        if let second = valueSecond{
            secondString = "\(second)"
        }
        if let third = valueThird{
            thirdString = "\(third)"
        }
        if let fourth = valueFourth{
            fourthString = "\(fourth)"
        }
        
        
        let userId = UserDefaults.standard.object(forKey: USER_ID) as! String
        let parmDict = ["user_id" : userId ,"method_name" : ApiUrl.METHOD_DONE_UNDONE_TASK , "milestone_cat_id" : currentCategoryId , "task_id" : taskID , "status": status , "milestone_id" : "\(currentMileStoneNo)" , "amount_1" : firstString , "amount_2" : secondString , "amount_3" : thirdString , "amount_4" : fourthString] as [String : Any]
        print("parmDict \(parmDict)")
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        ApiManager.sharedInstance.requestApiServer(parmDict, [UIImage](), {(data) ->() in
            MBProgressHUD.hide(for: self.view, animated: true)
            self.responseWithTaskStatus(data)
        }, {(error)-> () in
            print("failure \(error)")
            MBProgressHUD.hide(for: self.view, animated: true)
            self.view.makeToast(NETWORK_ERROR)
            
            
        },{(progress)-> () in
            print("progress \(progress)")
            
        })
        
    }
    func responseWithTaskStatus(_ userData : Any){
        let dictionary = userData as! NSDictionary
        let status = dictionary["status"] as? Int
        let msg = dictionary["msg"] as? String
        if(status == 1){
            canReload = true
            let model = dataModel?.data?[currentIndex]
            if(model?.status == "1"){
                model?.status = "0"
                if(model?.calculation == "1"){
                    model?.value = "0,0,0,0"
                }
                self.view.makeToast("Task is marked as incomplete")

            }else{
                model?.status = "1"
                if(model?.calculation == "1"){
                    
                    model?.value = getStringValue()
                }
                self.view.makeToast("Task is marked as completed")

            }
            let indexPath = IndexPath.init(row: currentIndex, section: 0)
            taskTableView.reloadRows(at: [indexPath], with: .automatic)
            //checkForTaskCompletion()
        }else{
            self.view.makeToast(msg!)

        }
        
    }
    
//    func checkForTaskCompletion(){
//        canReload = false
//        for model in (dataModel?.data)! {
//            if(model.status == "0"){
//                canReload = true
//                break
//            }
//        }
//        
//    }

}


extension TaskViewController{
    
    func requestAddTaskAPI(){
        //{"method_name":"add_user_tasks","milestone_cat_id":"2","user_id":"11","name":"my new tasks"}


      let userId = UserDefaults.standard.object(forKey: USER_ID) as! String
        let parmDict = ["user_id" : userId ,"method_name" : ApiUrl.METHOD_ADD_TASK , "milestone_cat_id" : currentCategoryId , "name" : addTaskTextView.text] as [String : Any]
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        ApiManager.sharedInstance.requestApiServer(parmDict, [UIImage](), {(data) ->() in
            MBProgressHUD.hide(for: self.view, animated: true)
            self.responseWithAddTask(data)
        }, {(error)-> () in
            print("failure \(error)")
            MBProgressHUD.hide(for: self.view, animated: true)
            self.view.makeToast(NETWORK_ERROR)
            
            
        },{(progress)-> () in
            print("progress \(progress)")
            
        })
        
    }
    func responseWithAddTask(_ userData : Any){
        let dictionary = userData as! NSDictionary
        let status = dictionary["status"] as? Int
        let msg = dictionary["msg"] as? String
        if(status == 1){
            self.view.makeToast("New task added successfully")
            addTaskPopupView.removeFromSuperview()
            requestTaskAPI()
        }else{
            
        }
        //self.view.makeToast(msg!)
        
    }
    
}



