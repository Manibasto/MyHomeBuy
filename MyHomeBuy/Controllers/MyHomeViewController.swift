//
//  MyHomeViewController.swift
//  MyHomeBuy
//
//  Created by Vikas on 05/10/17.
//  Copyright © 2017 MobileCoderz. All rights reserved.
//

import UIKit
import MBProgressHUD
import PieCharts
class MyHomeViewController: UIViewController {
    var currentMileStone = 1
    @IBOutlet weak var navigationBarView: UIView!
    //let chart = PieChart()
    let chart = VBPieChart()
    @IBOutlet weak var chartView: UIView!
    
    @IBOutlet weak var mileStoneLbl: UILabel!
    @IBOutlet weak var mileStoneView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        navigationBarView.setBottomShadow()
        
    }
    
    func setupChartData(_ statusArray : [String]){
        let chartModelData = ChartDataModel()
        //chartModelData.getChartdata(currentMileStone)
        chartModelData.getProperData(statusArray)

        chart.setChartValues(chartModelData.chartArray, animation:true , options: VBPieChartAnimationOptions.fanAll)
        chart.isUserInteractionEnabled = false
    }
    func initChart(_ statusArray : [String]){
    
        //chartView.backgroundColor = UIColor.gray
        chartView.addSubview(chart)
        var minLength = chartView.frame.size.width
        if(chartView.frame.size.width > chartView.frame.size.height){
         minLength = chartView.frame.size.height
        }
        let chartLength = minLength * 0.56
        chart.frame = CGRect(x: 0, y: 0, width: chartLength, height: chartLength)
        chart.center = CGPoint(x: chartView.frame.size.width/2, y: chartView.frame.size.height/2)
        chart.holeRadiusPrecent = 0.55;
        chart.startAngle = 30;
         setupChartData(statusArray)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        frostedViewController.panGestureEnabled = true
        requestMileStoneAPI()

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func menuBtnPressed(_ sender: Any) {
        frostedViewController.presentMenuViewController()
        
    }
    @IBAction func settingBtnPressed(_ sender: Any) {
        refreshHomeMenuUI()
        let settingVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SettingViewController") as! SettingViewController
        self.navigationController?.pushViewController(settingVC, animated: true)
        
    }
    
    
    @IBAction func mileStoneBtnPressed(_ sender: Any) {
        refreshHomeMenuUI()
        let navController : UINavigationController  = self.storyboard?.instantiateViewController(withIdentifier: "SlidingNavigationController") as! UINavigationController
        let tabBarController = self.storyboard?.instantiateViewController(withIdentifier: "CustomTabBar") as! UITabBarController
        navController.viewControllers = [tabBarController]
        
        tabBarController.selectedIndex = 0
        let navVC = tabBarController.selectedViewController as? UINavigationController
        let vcArray =  navVC?.viewControllers
        for vc in vcArray! {
            if(vc.isKind(of: MainMileStoneViewController.self)){
                let currentVC =  vc as! MainMileStoneViewController
                 //currentVC.currentMileStoneNo = currentMileStone
                break
            }
        }
        //        let vcArray = tabBarController.viewControllers
        //        for vc in vcArray! {
        //            if(vc.isKind(of: MainMileStoneViewController.self)){
        //                let currentVC =  vc as! MainMileStoneViewController
        //                currentVC.currentMileStoneNo = currentMileStone
        //                break
        //            }
        //        }
        
        self.frostedViewController.contentViewController = navController
    }
    func refreshHomeMenuUI(){
        let vc =  self.frostedViewController.menuViewController as! SideMenuViewController
        vc.currentIndex = 0
        
    }
    @IBAction func resourceBtnPressed(_ sender: Any) {
        refreshHomeMenuUI()
        let navController : UINavigationController  = self.storyboard?.instantiateViewController(withIdentifier: "SlidingNavigationController") as! UINavigationController
        let tabBarController = self.storyboard?.instantiateViewController(withIdentifier: "CustomTabBar") as! UITabBarController
        navController.viewControllers = [tabBarController]
        tabBarController.selectedIndex = 1
        //var firstVC = tabBarController[0] as! MainMileStoneViewController
        //firstVC.curr
        self.frostedViewController.contentViewController = navController
    }
    
    @IBAction func searchBtnPressed(_ sender: Any) {
        refreshHomeMenuUI()
        let navController : UINavigationController  = self.storyboard?.instantiateViewController(withIdentifier: "SlidingNavigationController") as! UINavigationController
        let tabBarController = self.storyboard?.instantiateViewController(withIdentifier: "CustomTabBar") as! UITabBarController
        navController.viewControllers = [tabBarController]
        //var firstVC = tabBarController[0] as! MainMileStoneViewController
        //firstVC.curr
        tabBarController.selectedIndex = 2
        self.frostedViewController.contentViewController = navController
    }
    
    @IBAction func propertyBtnPressed(_ sender: Any) {
        refreshHomeMenuUI()
        let navController : UINavigationController  = self.storyboard?.instantiateViewController(withIdentifier: "SlidingNavigationController") as! UINavigationController
        let tabBarController = self.storyboard?.instantiateViewController(withIdentifier: "CustomTabBar") as! UITabBarController
        navController.viewControllers = [tabBarController]
        //var firstVC = tabBarController[0] as! MainMileStoneViewController
        //firstVC.curr
        tabBarController.selectedIndex = 3
        
        self.frostedViewController.contentViewController = navController
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    func requestMileStoneAPI(){
        let userId = UserDefaults.standard.object(forKey: USER_ID) as! String
        let parmDict = ["user_id" : userId ,"method_name" : ApiUrl.METHOD_GET_MILESTONES_URL] as [String : Any]
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        ApiManager.sharedInstance.apiCall(parmDict, [UIImage](), {(data) ->() in
            self.responseWithSuccess(data)
            MBProgressHUD.hide(for: self.view, animated: true)
        }, {(error)-> () in
            print("failure \(error)")
            MBProgressHUD.hide(for: self.view, animated: true)
            self.view.makeToast(NETWORK_ERROR)
            let data = ["0","0","0","0","0","0","0"]
            self.initChart(data)
            
        },{(progress)-> () in
            print("progress \(progress)")
            
        })
        
    }
    func responseWithSuccess(_ userData : Any){
        
        let dataModel = Home_Base(dictionary: userData as! NSDictionary)
        if(dataModel?.status == 1){
            var data = [String]()
            currentMileStone = 1
            for model in (dataModel?.data)! {
                if(model.status! != "0" ){
                    currentMileStone += 1
                    //break
                    data.append("1")
                }else{
                    data.append("0")
                }
            }
            
            initChart(data)
            mileStoneLbl.text = "\(currentMileStone - 1)/7"
            print("current mileStone  \(currentMileStone)")
        }else{
            self.view.makeToast("Unable to fetch data")
        }
    }
}
