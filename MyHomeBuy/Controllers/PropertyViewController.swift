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
    var currenttag = -1
    
    @IBOutlet weak var propertyTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        //addLongPressGesture()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        frostedViewController.panGestureEnabled = true
        requestGetAllPropertyAPI()
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
        
        if let myInteger = Float(price!) {
            let myNumber = NSNumber(value:myInteger)
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = NumberFormatter.Style.decimal
            let price = numberFormatter.string(from: myNumber)
            cell.priceLbl.text = "$ \(price!)"
        }
       
        
        
      //  cell.priceLbl.text = "$ \(price!)"
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
        
       // cell.editButton.addTarget(self, action: #selector(editButtonTapped(_:)), for: .touchUpInside)
       // cell.editButton.tag = indexPath.row
        
        return cell
    }
    
//    func editButtonTapped(_ button : UIButton){
//        let model = dataModel?.data?[button.tag]
//
//        let navController : UINavigationController  = storyboard?.instantiateViewController(withIdentifier: "SlidingNavigationController") as! UINavigationController
//        let controller = storyboard?.instantiateViewController(withIdentifier: "AddPropertyViewController") as? AddPropertyViewController
//        controller?.canAdd = false
//        controller?.propertyModel = model
//        navController.viewControllers = [controller!]
//        frostedViewController.contentViewController = navController
//    }
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
extension PropertyViewController{

//func addLongPressGesture() {
//    let lpgr = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
//    // lpgr.delegate = self
//    lpgr.delaysTouchesBegan = true
//    propertyTableView.addGestureRecognizer(lpgr)
//
//}
//func handleLongPress(_ gestureRecognizer : UILongPressGestureRecognizer)
//{
//    if(gestureRecognizer.state != .ended){
//        return
//    }
//
//    let p  = gestureRecognizer.location(in: propertyTableView)
//    // if  let indexPath = propertyTableView.indexPathForItem(at: p){
//    if let indexPath = propertyTableView.indexPathForRow(at: p){
//           currenttag = indexPath.row
//           showAlert("MyHomeBuy", "Do you really want to delete this image?")
//
//        // showAlert("MyHomeBuy", "Do you really want to delete this image?", DocumentType.Image)
//
//    }
//
////}
//func showAlert(_ title : String , _ msg : String ){
//
//    let alertController = UIAlertController(title: title, message: msg, preferredStyle: UIAlertControllerStyle.alert)
//
//    let DestructiveAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: "nil"), style: .default) {
//        (result : UIAlertAction) -> Void in
//        print("Destructive")
//    }
//
//
//    let okAction = UIAlertAction(title: NSLocalizedString("OK", comment: "nil"), style: UIAlertActionStyle.default) {
//        (result : UIAlertAction) -> Void in
//
//        let model = self.dataModel?.data?[self.currenttag]
//       // self.requestDeletePropertAPI(self.currenttag, (model?.id)!)
//        self.requestDeletePropertAPI(self.currenttag, (model?.id)!, _image: (model?.image)!)
//
//        //            if(type == .Image){
//        //                let model = self.imageArray[self.currenttag]
//        //                // self.deleteDocumentAPI(self.currenttag, model.id!)
//        //                self.deleteImageAPI(self.currenttag, model.id!)
//        //
//        //            }else{
//        //                let model = self.pdfArray[self.currenttag]
//        //                self.deleteDocumentAPI(self.currenttag, model.id!)
//        //
//        //            }
//
//        print("OK")
//
//    }
//
//    alertController.addAction(DestructiveAction)
//    alertController.addAction(okAction)
//    self.present(alertController, animated: true, completion: nil)
//    alertController.view.tintColor = UIColor.black
//
//}
}

/*
extension PropertyViewController
{
    func requestDeletePropertAPI(_ tag : Int , _ id : String , _image :String ){
        //  {"id":"3","method_name":"delete_user_document"}
        //let userId = UserDefaults.standard.object(forKey: USER_ID) as! String
        
        let parmDict = ["id" : id,"method_name" : ApiUrl.METHOD_DELETE_PROPERTY,"tablename" : "user_property"] as [String : Any]
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        ApiManager.sharedInstance.apiCall(parmDict, [UIImage](), {(data) ->() in
            
            let dictionary = data as! NSDictionary
            
            let status = dictionary["status"] as? Int
            let msg = dictionary["msg"] as? String
            if(status == 1){
              //  self.pdfArray.remove(at: tag)
             //   self.pdfTableView.reloadData()
                  self.propertyTableView.reloadData()
                self.view.makeToast("Image deleted succesfully")
            }else{
                self.view.makeToast(msg!)
            }
            
            
            MBProgressHUD.hide(for: self.view, animated: true)
        }, {(error)-> () in
            print("failure \(error)")
            MBProgressHUD.hide(for: self.view, animated: true)
            self.view.makeToast(NETWORK_ERROR)
            
            
        },{(progress)-> () in
            print("progress \(progress)")
            
        })
        
    }
    
}
 */
