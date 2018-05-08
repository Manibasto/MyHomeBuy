//
//  MainMileStoneViewController.swift
//  MyHomeBuy
//
//  Created by Vikas on 23/10/17.
//  Copyright © 2017 MobileCoderz. All rights reserved.
//

import UIKit
import Toast_Swift
import MBProgressHUD
class MainMileStoneViewController: UIViewController {
    var dataArray = [Any]()
    var currentMileStoneNo = 7
    var dataModel = Home_Base(dictionary: ["" : ""])
    @IBOutlet weak var navigationBarView: UIView!
    @IBOutlet weak var mileStoneTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
     
        navigationBarView.setBottomShadow()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        frostedViewController.panGestureEnabled = true
        requestMileStoneAPI()
        //loadWithoutAPI()
    }
    
    func loadWithoutAPI()
    {
    initData()
    mileStoneTableView.delegate = self
    mileStoneTableView.dataSource = self
    mileStoneTableView.reloadData()
    }
    
    func initData()
    {
        dataArray.removeAll()
        let data1 = ["image" : "main_budget_icon" , "colorCode" : UIColor.mileStoneColor1 , "text" : "BUDGET"] as [String : Any]
        let data2 = ["image" : "main_start_looking_icon" , "colorCode" : UIColor.mileStoneColor2 , "text" : "LET'S START LOOKING"] as [String : Any]
         let data3 = ["image" : "main_offer_icon" , "colorCode" : UIColor.mileStoneColor3 , "text" : "OFFER TO PURCHASE"] as [String : Any]
         let data4 = ["image" : "main_legal_icon" , "colorCode" : UIColor.mileStoneColor4 , "text" : "LEGAL"] as [String : Any]
         let data5 = ["image" : "main_contract_icon" , "colorCode" : UIColor.mileStoneColor5 , "text" : "CONTRACT"] as [String : Any]
         let data6 = ["image" : "main_property_settlement_icon" , "colorCode" : UIColor.mileStoneColor6 , "text" : "PROPERTY SETTLEMENT"] as [String : Any]
         let data7 = ["image" : "main_moving_icon" , "colorCode" : UIColor.mileStoneColor7 , "text" : "MOVING IN"] as [String : Any]
        
        dataArray.append(data1)
        dataArray.append(data2)
        dataArray.append(data3)
        dataArray.append(data4)
        dataArray.append(data5)
        dataArray.append(data6)
        dataArray.append(data7)

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func menuBtnPressed(_ sender: Any)
    {
        frostedViewController.presentMenuViewController()
    }
    
    @IBAction func homeBtnPressed(_ sender: Any) {
        let navController : UINavigationController  = storyboard?.instantiateViewController(withIdentifier: "SlidingNavigationController") as! UINavigationController
        var controller: UIViewController!
        
        controller = storyboard?.instantiateViewController(withIdentifier: "MyHomeViewController") as? MyHomeViewController
        
        navController.viewControllers = [controller]
        
        frostedViewController.contentViewController = navController
    }
    
}

extension MainMileStoneViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count;
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dict = dataArray[indexPath.row] as! NSDictionary
            let cell = tableView.dequeueReusableCell(withIdentifier: "MainMileStoneTableCell", for: indexPath) as! MainMileStoneTableCell;
        cell.headingBtn.isUserInteractionEnabled = false
//        if(indexPath.row  < currentMileStoneNo ){
//            cell.nextImageView.isHidden = false
//            cell.overlayView.isHidden = true
//        }else{
//            cell.nextImageView.isHidden = true
//            cell.overlayView.isHidden = false
//
//
//        }
        cell.nextImageView.isHidden = false
        cell.overlayView.isHidden = true
        let image = UIImage.init(named: (dict.object(forKey: "image") as! String?)!)
            cell.headingBtn.setImage(image, for: .normal)
        let title = dict.object(forKey: "text") as! String?
        cell.headingBtn.setTitle("  \(title!)", for: .normal)
        let color = dict.object(forKey: "colorCode") as! UIColor?
        cell.contentView.backgroundColor = color
          return cell
    }
}
extension MainMileStoneViewController : UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
         SharedAppDelegate.logEvents(itemID: "02", itemName: "Visit", contentType: "Milestone \(indexPath.row+1)")
            let mileStoneVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MileStoneViewController") as! MileStoneViewController
            mileStoneVC.currentMileStoneNo = indexPath.row+1
        if(indexPath.row == 1)
        {
        let model = dataModel?.data?[indexPath.row]
            let additionalInfoInt = model?.completed
            print("additionalInfoInt \(additionalInfoInt!)")
            mileStoneVC.additionalInfo = "\(additionalInfoInt!)"
        }
            self.navigationController?.pushViewController(mileStoneVC, animated: true)
         print("selected")
    }
//    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
//        if(indexPath.row  < currentMileStoneNo ){
//            return indexPath
//        }
//        view.makeToast("MileStone Locked")
//        return nil
//    }
}
extension MainMileStoneViewController{
    func requestMileStoneAPI(){
        let userId = UserDefaults.standard.object(forKey: USER_ID) as! String
        let parmDict = ["user_id" : userId ,"method_name" : ApiUrl.METHOD_GET_MILESTONES_URL] as [String : Any]
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        ApiManager.sharedInstance.requestApiServer(parmDict, [UIImage](), {(data) ->() in
            self.responseWithSuccess(data)
            MBProgressHUD.hide(for: self.view, animated: true)
        }, {(error)-> () in
            print("failure \(error)")
            MBProgressHUD.hide(for: self.view, animated: true)
            self.view.makeToast(NETWORK_ERROR)
            self.dataArray.removeAll()
            self.mileStoneTableView.reloadData()
        },{(progress)-> () in
            print("progress \(progress)")
            
        })
    }
    func responseWithSuccess(_ userData : Any){
         dataModel = Home_Base(dictionary: userData as! NSDictionary)
        if(dataModel?.status == 1){
            currentMileStoneNo = 1
            for model in (dataModel?.data)! {
                if( Int(model.status!)! != 0 ){
                    currentMileStoneNo += 1
                    //break
                }
            }
            initData()
            mileStoneTableView.delegate  = self
            mileStoneTableView.dataSource = self
            mileStoneTableView.reloadData()
            print("current mileStone  \(currentMileStoneNo)")
        }else
        {
            self.view.makeToast("Unable to fetch data")
        }
    }
}
