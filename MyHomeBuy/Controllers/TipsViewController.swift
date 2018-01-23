//
//  TipsViewController.swift
//  MyHomeBuy
//
//  Created by Vikas on 26/10/17.
//  Copyright © 2017 MobileCoderz. All rights reserved.
//

import UIKit
import MBProgressHUD
import Toast_Swift
class TipsViewController: UIViewController {
    @IBOutlet weak var tipsLbl: UILabel!
    @IBOutlet weak var tipsImageView: UIImageView!
    @IBOutlet weak var tipsHeadingView: UIView!
    @IBOutlet weak var navigationBarView: UIView!
    @IBOutlet weak var tipsTableView: UITableView!
    var currentCategoryId = "-1"
    //let categoryIds = [""]
    var dataDict = NSDictionary()
    var dataModel = TipsBase(dictionary: ["" : ""] )
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        frostedViewController.panGestureEnabled = false
        //navigationBarView.setBottomShadow()
        //tipsHeadingView.setBottomShadow()
        tipsTableView.dataSource = self
        tipsTableView.estimatedRowHeight = 60
        tipsTableView.rowHeight = UITableViewAutomaticDimension
        setupHeaderData()
        requestTipsAPI()
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        navigationBarView.setBottomShadow()
        tipsHeadingView.setBottomShadow()
    }
    func setupHeaderData(){
        let image = UIImage.init(named: (dataDict.object(forKey: "image_white") as! String?)!)
        tipsImageView.image = image
        let title = dataDict.object(forKey: "headerText") as! String?
        tipsLbl.text = title
        let color = dataDict.object(forKey: "colorCode") as! UIColor?
        navigationBarView.backgroundColor = color
        tipsHeadingView.backgroundColor = color
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
    func requestTipsAPI(){

        //let userId = UserDefaults.standard.object(forKey: USER_ID) as! String    "user_id" : userId ,
        let parmDict = ["method_name" : ApiUrl.METHOD_GET_TIPS , "milestone_cat_id" : currentCategoryId] as [String : Any]
        
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
        
        dataModel = TipsBase(dictionary: userData as! NSDictionary)
        if(dataModel?.status == 1){
            tipsTableView.reloadData()
            
        }else{
            
            self.view.makeToast("Unable to fetch data")
        }
    }
}

extension TipsViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      let str = dataModel?.data?.name
        if(str == nil){
        return 0
        }
        let strArray = str?.components(separatedBy: "\n")
            return (strArray?.count)!
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let str = dataModel?.data?.name
        let strArray = str?.components(separatedBy: "\n")
        let cell = tableView.dequeueReusableCell(withIdentifier: "TipsTableCell", for: indexPath) as! TipsTableCell;
        if(currentCategoryId == "3" || currentCategoryId == "4" || currentCategoryId == "6"){
            if(indexPath.row == 0){
           let customFont = UIFont.init(name: "AvenirNextLTPro-Bold", size: 17)
            cell.detailLbl.font = customFont
            }else{
                let customFont = UIFont.init(name: "AvenirNextLTPro-Regular", size: 17)
                cell.detailLbl.font = customFont
            }
            
            
        }
      cell.detailLbl.text = strArray?[indexPath.row]
        if(indexPath.row % 2 == 0){
            cell.contentView.backgroundColor = UIColor.lighterGray
            }else{
            cell.contentView.backgroundColor = UIColor.white
            }
       
        return cell
        
        
    }

}
