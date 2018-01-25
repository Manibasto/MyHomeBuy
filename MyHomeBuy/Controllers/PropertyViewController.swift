//
//  PropertyViewController.swift
//  MyHomeBuy
//
//  Created by Vikas on 13/11/17.
//  Copyright © 2017 MobileCoderz. All rights reserved.
//

import UIKit
import MBProgressHUD
import SwiftyJSON
class PropertyViewController: UIViewController {
    
    @IBOutlet weak var addPropertyBtn: UIButton!
    @IBOutlet var footerView: UIView!
    var dataModel = GetPropertyDetailBase(dictionary: ["" : ""] )
    
    @IBOutlet weak var propertyTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        requestGetAllPropertyAPI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        frostedViewController.panGestureEnabled = true
        addFooterView()
    }
    func addFooterView(){
        footerView.frame(forAlignmentRect: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 80))
        propertyTableView.tableFooterView = footerView
        let titleColor = addPropertyBtn.titleColor(for: .normal)
        addPropertyBtn.setRadius(10, titleColor!, 2)
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func menuBtnPressed(_ sender: Any) {
        frostedViewController.presentMenuViewController()
    }
    
    @IBAction func homeBtnPressed(_ sender: Any) {
        let navController : UINavigationController  = storyboard?.instantiateViewController(withIdentifier: "SlidingNavigationController") as! UINavigationController
        var controller: UIViewController!
        
        controller = storyboard?.instantiateViewController(withIdentifier: "MyHomeViewController") as? MyHomeViewController
        
        navController.viewControllers = [controller]
        
        frostedViewController.contentViewController = navController
    }
    
    
    @IBAction func addPropertyBtnPressed(_ sender: Any) {
         let navController : UINavigationController  = storyboard?.instantiateViewController(withIdentifier: "SlidingNavigationController") as! UINavigationController
            let controller = storyboard?.instantiateViewController(withIdentifier: "AddPropertyViewController") as? AddPropertyViewController
        navController.viewControllers = [controller!]
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

extension PropertyViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (dataModel?.data?.count)!
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GetPropertyTableCell", for: indexPath) as! GetPropertyTableCell;
        let model = dataModel?.data?[indexPath.row]
        let noOfBathrooms = model?.bathrooms
        let noOfBedrooms = model?.bedrooms
        let noOfGarage = model?.car_parking_garage
        cell.propertyImageView.setRadius(10)
        cell.addressLbl.text = model?.address
        let price = model?.price
        cell.priceLbl.text = "$ \(price!)"
        cell.bathRoomBtn.setTitle(" \(noOfBathrooms!)", for: .normal)
        cell.garageBtn.setTitle(" \(noOfGarage!)", for: .normal)
        cell.bedRoomBtn.setTitle(" \(noOfBedrooms!)", for: .normal)
        
        // cell.profileImageView.sd_setImage(with: URL(string: (model?.image)!)) { (image, error, cache, url) in
        //cell.propertyImageView.image = ""
        
        let imgArray = model?.image?.components(separatedBy: ",")
        if let count = imgArray?.count{
            if(count > 0){
                cell.propertyImageView.sd_setImage(with: URL(string: (imgArray?[0])!), placeholderImage: UIImage.init(named: "add_home_placeholder"))
            }else{
                cell.propertyImageView.image = UIImage.init(named: "add_home_placeholder")
            }
        }else{
            cell.propertyImageView.image = UIImage.init(named: "add_home_placeholder")

        }
        
        
        
        return cell
    }
    
    
}
extension PropertyViewController : UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PropertyDetailViewController") as! PropertyDetailViewController
        let model = dataModel?.data?[indexPath.row]
        vc.model = model
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}

extension PropertyViewController{
    func requestGetAllPropertyAPI(){
        //    {
        //    "method_name":"get_user_Property",
        //    "user_id":"11"
        //
        //    }
        
        
        
        let userId = UserDefaults.standard.object(forKey: USER_ID) as! String
        let parmDict = ["user_id" : userId ,"method_name" : ApiUrl.METHOD_GET_PROPERTY_DETAILS ] as [String : Any]
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        ApiManager.sharedInstance.requestApiServer(parmDict, [UIImage](), {(data) ->() in
            MBProgressHUD.hide(for: self.view, animated: true)
            self.responseOfGetAllProperty(data)
        }, {(error)-> () in
            print("failure \(error)")
            MBProgressHUD.hide(for: self.view, animated: true)
            self.view.makeToast(NETWORK_ERROR)
        },{(progress)-> () in
            print("progress \(progress)")
            
        })
        
    }
    func responseOfGetAllProperty(_ userData : Any){
        dataModel = GetPropertyDetailBase(dictionary: userData as! NSDictionary)
        if(dataModel?.status == 1){
            //self.view.makeToast("Got property detail successfully")
            if((dataModel?.data?.count)! > 0){
                setupControllerData()

            }else{
                self.view.makeToast("No property available")

            }
        }else{
            
            self.view.makeToast("No property available")
        }
    }
  
    func setupControllerData(){
        propertyTableView.delegate = self
        propertyTableView.dataSource = self
//        propertyTableView.rowHeight = UITableViewAutomaticDimension
//        propertyTableView.estimatedRowHeight = 150
        propertyTableView.reloadData()
        
    }
}
