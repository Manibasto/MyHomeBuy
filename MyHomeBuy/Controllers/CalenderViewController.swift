//
//  CalenderViewController.swift
//  MyHomeBuy
//
//  Created by Vikas on 09/11/17.
//  Copyright © 2017 MobileCoderz. All rights reserved.
//

import UIKit
import MBProgressHUD
import Toast_Swift
import FSCalendar
import EventKit
class CalenderViewController: UIViewController {
    @IBOutlet var adddEventPopupView: UIView!
    
    @IBOutlet weak var waterMarkLbl: UILabel!
    
    @IBOutlet weak var calenderView: UIView!
    @IBOutlet weak var eventsTableView: UITableView!
    @IBOutlet weak var headingHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var headingLbl: UILabel!
    @IBOutlet weak var headingImageView: UIImageView!
    @IBOutlet weak var navigationBarView: UIView!
    var dataDict = NSDictionary()
    var currentTaskID = "0"
    @IBOutlet weak var headingView: UIView!
    var dataModel = EventBase(dictionary: ["" : ""] )
    var fromTask = false
    @IBOutlet weak var cancelBtn: UIButton!
    
    @IBOutlet weak var saveBtn: UIButton!
    
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var subjectTextField: UITextField!
    
    @IBOutlet weak var timeTextField: UITextField!
    @IBOutlet weak var midPopup: UIView!
    
    @IBOutlet weak var dateLbl: UILabel!
    //////////////
    @IBOutlet var timePickerPopupView: UIView!
    
   
  //  pickerDoneBtnAction
    @IBOutlet weak var timePickerView: UIDatePicker!
    var calender = FSCalendar()
    var selectedDate = ""
    var selectedDateObject = Date()
    var dateArray = [Date]()
    // header outlets
    var strTime = ""
    @IBOutlet weak var nextEventView: UIView!
    @IBOutlet var headerView: UIView!
    @IBOutlet weak var nextEventLbl: UILabel!
    
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
        
        createCalenderView()
        requestGetAllEventsAPI()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
   
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        //createCalenderView()
        //if(!calender .isDescendant(of: calenderView)){
        navigationBarView.setBottomShadow()
        headingView.setBottomShadow()
        calender.frame.size = calenderView.frame.size
        calenderView.addSubview(calender)
        //}
        
    }
    func createCalenderView(){
        calender = FSCalendar(frame: CGRect(x: 0, y: 0, width: calenderView.frame.size.width, height: calenderView.frame.size.height))
       //  [NSLocale localeWithLocaleIdentifier:@"zh-CN"];
        calender.locale = Locale(identifier: "en_US_POSIX")
        calender.delegate = self
        calender.dataSource = self
        calender.appearance.weekdayTextColor = UIColor.black
        calender.appearance.titleWeekendColor = UIColor.black
        calender.appearance.headerTitleColor = UIColor.black
        //calendar.appearance.eventColor = UIColor.greenColor
        //calendar.appearance.selectionColor = UIColor.blueColor
        //calendar.appearance.todayColor = UIColor.orangeColor
       // calendar.appearance.todaySelectionColor = UIColor.blackColor
    }
    func setupData(){
        
        
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
    
    @IBAction func pickerCancelButtonAction(_ sender: Any)
    {
        timePickerPopupView.removeFromSuperview()

    }
    @IBAction func pickerDoneBtnAction(_ sender: Any)
    {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = DateFormatter.Style.short
        dateFormatter.timeStyle = DateFormatter.Style.short
 

        dateFormatter.dateFormat = "HH:mm"
         strTime = dateFormatter.string(from: timePickerView.date)
       // let timeArray =  strDate.components(separatedBy: ", ")
        timeTextField.text = strTime
        timePickerPopupView.removeFromSuperview()
       // dateLabel.text = strDate
    }
    @IBAction func homeBtnPressed(_ sender: Any) {
        let navController : UINavigationController  = storyboard?.instantiateViewController(withIdentifier: "SlidingNavigationController") as! UINavigationController
        var controller: UIViewController!
        
        controller = storyboard?.instantiateViewController(withIdentifier: "MyHomeViewController") as? MyHomeViewController
        
        navController.viewControllers = [controller]
        frostedViewController.contentViewController = navController
        
    }
    
    
    func addEventBtnTapped(_ date : Date){
        print(date)
        selectedDateObject = date
        // Aug 29,2017
        //11-23-2017 09:41
        //MM-dd-yyyy HH:mm
        //yyyy-MM-dd HH:mm:ss Z
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        let stringDate =  dateFormatter.string(from: date)
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let currentSelectedDate =  dateFormatter.string(from: date)
        
        selectedDate = currentSelectedDate
        adddEventPopupView.frame = view.frame
        view.addSubview(adddEventPopupView)
        cancelBtn.addTarget(self, action: #selector(cancelBtnTapped), for: .touchUpInside)
        saveBtn.addTarget(self, action: #selector(saveBtnTapped), for: .touchUpInside)
        saveBtn.setRadius(10)
        cancelBtn.setRadius(10)
        midPopup.setRadius(5)
        descriptionTextView.delegate = self
        subjectTextField.applyPadding(padding: 5)
        timeTextField.applyPadding(padding: 5)
        dateLbl.text = "Event Date - \(stringDate)"
        subjectTextField.text = ""
        descriptionTextView.text = ""
        timeTextField.text = ""
        timeTextField.delegate = self
        
        
    }
    func saveBtnTapped(){
        view.endEditing(true)
        if(subjectTextField.text?.isEmpty)!{
            view.makeToast("Please enter subject")
        }else if(descriptionTextView.text.isEmpty){
            view.makeToast("Please enter description")
            
        }
        else if(timeTextField.text?.isEmpty)!{
            view.makeToast("Please enter time")
            
        }else{
            requestAddEventAPI()
        }
    }
    func cancelBtnTapped(){
        adddEventPopupView.removeFromSuperview()
        
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    func addEventToCalendar(title: String, description: String?, startDate: Date, endDate: Date, completion: ((_ success: Bool, _ error: NSError?) -> Void)? = nil) {
        let eventStore = EKEventStore()
        
        eventStore.requestAccess(to: .event, completion: { (granted, error) in
            if (granted) && (error == nil) {
                let event = EKEvent(eventStore: eventStore)
                event.title = title
                event.startDate = startDate
                event.endDate = endDate
                event.notes = description
                event.calendar = eventStore.defaultCalendarForNewEvents
                do {
                    try eventStore.save(event, span: .thisEvent)
                } catch let e as NSError {
                    self.showMsg("Unable to save event in your device")

                    completion?(false, e)
                    return
                }
                let timeInterval = TimeInterval(60 * -60)
                let alarm = EKAlarm(relativeOffset: timeInterval)
                event.addAlarm(alarm)
                self.showMsg("Event saved in your device")

                completion?(true, nil)
            } else {
                self.showMsg("No permission to add events")

                completion?(false, error as NSError?)
            }
        })
    }
    
    func showMsg(_ msg : String){
        DispatchQueue.main.async {
            self.view.makeToast(msg)
        }
    }
}
extension CalenderViewController : UITextViewDelegate{
    
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

extension CalenderViewController{
    func requestGetAllEventsAPI(){
        //{
        //        "method_name":"get_user_TaskCalendar",
        //        "user_id":"11",
        //        "task_id":"2"
        //
        //    }
        
        let userId = UserDefaults.standard.object(forKey: USER_ID) as! String
        let parmDict = ["user_id" : userId ,"method_name" : ApiUrl.METHOD_GET_EVENTS , "task_id" : currentTaskID] as [String : Any]
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        ApiManager.sharedInstance.requestApiServer(parmDict, [UIImage](), {(data) ->() in
            MBProgressHUD.hide(for: self.view, animated: true)
            self.responseOfGetAllEvents(data)
        }, {(error)-> () in
            print("failure \(error)")
            MBProgressHUD.hide(for: self.view, animated: true)
            self.view.makeToast(NETWORK_ERROR)
        },{(progress)-> () in
            print("progress \(progress)")
            
        })
        
    }
    func responseOfGetAllEvents(_ userData : Any){
        
        dataModel = EventBase(dictionary: userData as! NSDictionary)
        if(dataModel?.status == 1){
            eventsTableView.delegate = self
            eventsTableView.dataSource  = self
            eventsTableView.rowHeight = UITableViewAutomaticDimension
            eventsTableView.estimatedRowHeight = 50
            eventsTableView.reloadData()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            dateArray.removeAll()
            for model in (dataModel?.data)! {
                let dateStr = model.date
                
                if let date = dateFormatter.date(from: dateStr!)
                {
                    dateArray.append(date)
                    //                    calender.dataSource?.calendar!(calender, numberOfEventsFor: date)
                }else{
                    view.makeToast("Invalid Date Formate")
                    
                }
                
            }
            calender.reloadData()
            if let count = dataModel?.data?.count{
                if(count>0){
                addHeaderView()
                }else{
                    view.makeToast("No upcoming events available")

                }

            }
        }else{
            
            view.makeToast("No upcoming events available")
        }
        
    }
    func addHeaderView(){
        headerView.frame(forAlignmentRect: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 110))
        eventsTableView.tableHeaderView = headerView
       nextEventView.setRadius(5)
        let model = dataModel?.data?[0]
        let dateStr = model?.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let date = dateFormatter.date(from: dateStr!){
            dateFormatter.dateFormat = "MMM. dd, yyyy"

            let stringDate =  dateFormatter.string(from: date)
            nextEventLbl.text = "Next event on \(stringDate)"

        }else{
         nextEventLbl.text = "Invalid date formate"
        }
        
    }
}

extension CalenderViewController{
    func requestAddEventAPI(){
        //        {
        //            "method_name":"add_user_TaskCalendar",
        //            "user_id":"11",
        //            "task_id":"2",
        //            "subject":"composer ",
        //            "description":"please fill the composers",
        //            "date":"2017-07-20"
        //        }
        
        
        
        let userId = UserDefaults.standard.object(forKey: USER_ID) as! String
        let parmDict = ["user_id" : userId ,"time" : strTime ,"method_name" : ApiUrl.METHOD_ADD_EVENTS , "task_id" : currentTaskID , "subject" : subjectTextField.text! , "description" : descriptionTextView.text , "date" : selectedDate] as [String : Any]
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        ApiManager.sharedInstance.requestApiServer(parmDict, [UIImage](), {(data) ->() in
            MBProgressHUD.hide(for: self.view, animated: true)
            self.responseOfAddEvents(data)
        }, {(error)-> () in
            print("failure \(error)")
            MBProgressHUD.hide(for: self.view, animated: true)
            self.view.makeToast(NETWORK_ERROR)
        },{(progress)-> () in
            print("progress \(progress)")
            
        })
        
    }
    func responseOfAddEvents(_ userData : Any){
        dataModel?.data?.removeAll()
        eventsTableView.reloadData()
        dataModel = EventBase(dictionary: userData as! NSDictionary)
        if(dataModel?.status == 1){
            self.view.makeToast("Events added successfully")
            adddEventPopupView.removeFromSuperview()
            requestGetAllEventsAPI()
            saveEvent()
        }else{
            self.view.makeToast("Unable to  save events")
        }
    }
    
    func saveEvent(){
        addEventToCalendar(title: subjectTextField.text!, description: descriptionTextView.text, startDate: selectedDateObject, endDate: selectedDateObject)
        
    }
}
extension CalenderViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (dataModel?.data?.count)!
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventsTableCell", for: indexPath) as! EventsTableCell;
        let model = dataModel?.data?[indexPath.row]
        cell.nameLbl.text = model?.subject
        cell.descLbl.text = model?.description
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateStr = model?.created_date
        
        if let date = dateFormatter.date(from: dateStr!){
            dateFormatter.dateFormat = "MMM dd, yyyy hh:mm a"
            
            let stringDate =  dateFormatter.string(from: date)
            cell.dateLbl.text = stringDate
        }else{
            cell.dateLbl.text = model?.created_date
            
        }
//        if(indexPath.row % 2 != 0){
//            cell.contentView.backgroundColor = UIColor.lighterGray
//        }else{
//            cell.contentView.backgroundColor = UIColor.white
//            
//        }
        if let count = dataModel?.data?.count{
            if(indexPath.row == count-1){
            cell.bottomLineView.isHidden = true
            }else{
             cell.bottomLineView.isHidden = false
            }

        }
        return cell
    }
    
}
extension CalenderViewController : UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
    
    
}

extension CalenderViewController : FSCalendarDelegate{
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        addEventBtnTapped(date)
        
    }
    
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        let currentDate = Date()
        if(currentDate <= date){
            return true
            
        }
        view.makeToast("Please create an event for upcoming or current date")
        return false
    }
}

extension CalenderViewController : FSCalendarDataSource{
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        if(dateArray.contains(date)){
            return 1
        }
        return 0
    }
    
}

extension CalenderViewController : UITextFieldDelegate
{
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == timeTextField{
            view.endEditing(true)
            timePickerPopupView.frame = view.frame
            view.addSubview(timePickerPopupView)
        return false
    }
        return true
    }
    
}



