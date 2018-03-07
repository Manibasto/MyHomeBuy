//
//  PropertyDetailViewController.swift
//  MyHomeBuy
//
//  Created by Vikas on 13/11/17.
//  Copyright © 2017 MobileCoderz. All rights reserved.
//

import UIKit
import MBProgressHUD
import Toast_Swift
class PropertyDetailViewController: UIViewController {
    var model = GetPropertyDetailModel(dictionary: ["" : ""] )
    
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var propertyDetailImageCollectionView: UICollectionView!
    @IBOutlet weak var rightBtn: UIButton!
    
    @IBOutlet weak var leftBtn: UIButton!
    
    @IBOutlet weak var bedroomLbl: UILabel!
    
    @IBOutlet weak var parkingLbl: UILabel!
    @IBOutlet weak var bathRoomLbl: UILabel!
    
    @IBOutlet weak var agentNoBtn: UIButton!
    @IBOutlet weak var agentNameBtn: UIButton!
    @IBOutlet weak var detailLbl: UILabel!
    @IBOutlet weak var areaLbl: UILabel!
    
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var propertyInfoView: UIView!
    var currentIndex = 0
    @IBOutlet weak var contactAgentView: UIView!
    @IBOutlet weak var navigationBarView: UIView!
    @IBOutlet weak var homeDetailView: UIView!
    @IBOutlet weak var editPropertyBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
       // navigationBarView.setBottomShadow()

        frostedViewController.panGestureEnabled = false
        leftBtn.isHidden = true
        setUpData()
        setupControllerData()
        //requestGetPropertyDetailsAPI()
        
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        navigationBarView.setBottomShadow()
    }
    func setUpData(){
        homeDetailView.setRadius(5)
        contactAgentView.setRadius(5)
        homeDetailView.setRadius(5)
       // let titleColor = editPropertyBtn.titleColor(for: .normal)
       // editPropertyBtn.setRadius(10, titleColor!, 2)
        
        rightBtn.addTarget(self, action: #selector(rightBtnTapped), for: .touchUpInside)
        leftBtn.addTarget(self, action: #selector(leftBtnTapped), for: .touchUpInside)
        
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        let pageWidth = scrollView.frame.width
        let currentPage = Int((scrollView.contentOffset.x + pageWidth / 2) / pageWidth)
        print("currentPage  \(currentPage)")
        currentIndex = currentPage
        let imageArray =  model?.image?.components(separatedBy: ",")
        
        if let count = imageArray?.count{
            if(count > 1){
                
                if(currentPage == count - 1){
                    //last
                    rightBtn.isHidden = true
                    leftBtn.isHidden = false
                    
                }else if (currentPage == 0){
                    rightBtn.isHidden = false
                    leftBtn.isHidden = true
                    
                }else{
                    rightBtn.isHidden = false
                    leftBtn.isHidden = false
                }
            }
        }
    }
    func rightBtnTapped(){
        let imageArray =  model?.image?.components(separatedBy: ",")
        
        if(currentIndex >= (imageArray?.count)! - 1){
            return
        }
        //        let indexPathArray = propertyDetailImageCollectionView.indexPathsForVisibleItems
        //        print(indexPathArray)
        let indexPath = IndexPath.init(row: currentIndex + 1, section: 0)
        propertyDetailImageCollectionView.scrollToItem(at: indexPath, at: .right, animated: true)
        //currentIndex += 1
    }
    
    func leftBtnTapped(){
        if(currentIndex <= 0){
            return
        }
        //        let indexPathArray = propertyDetailImageCollectionView.indexPathsForVisibleItems
        //        print(indexPathArray)
        let indexPath = IndexPath.init(row: currentIndex - 1, section: 0)
        propertyDetailImageCollectionView.scrollToItem(at: indexPath, at: .left, animated: true)
        //currentIndex -= 1
        
    }
    func setupControllerData(){
        let imageArray =  model?.image?.components(separatedBy: ",")
        
        if let count = imageArray?.count{
            if(count > 0){
                propertyDetailImageCollectionView.dataSource = self
                propertyDetailImageCollectionView.delegate = self
                propertyDetailImageCollectionView.reloadData()
                if(count == 1){
                    rightBtn.isHidden = true
                    leftBtn.isHidden = true
                }
            }
        }else{
            model?.image = "qwerty"
            propertyDetailImageCollectionView.dataSource = self
            propertyDetailImageCollectionView.delegate = self
            propertyDetailImageCollectionView.reloadData()
            rightBtn.isHidden = true
            leftBtn.isHidden = true
        }
        
        // let model = dataModel?.data?[0]
        let noOfBathrooms = model?.bathrooms
        let noOfBedrooms = model?.bedrooms
        let noOfGarage = model?.car_parking_garage
        let area = model?.area_sqft
        
        bathRoomLbl.text = ". \(noOfBathrooms!) Bathrooms"
        parkingLbl.text = ". \(noOfGarage!) Car Parking"
        bedroomLbl.text = ". \(noOfBedrooms!) Bedrooms"
        areaLbl.text = ". \(area!) Area"
        detailLbl.text = model?.description
        agentNameBtn.setTitle(model?.agent_name, for: .normal)
        agentNoBtn.setTitle(String.phoneNumberFormate(num: (model?.agent_contact)!), for: .normal)
        let price = model?.price
        
        if let myInteger = Float(price!) {
            let myNumber = NSNumber(value:myInteger)
            let numberFormatter = NumberFormatter()
            //  numberFormatter.numberStyle = .currency
            numberFormatter.numberStyle = NumberFormatter.Style.currency
            let price = numberFormatter.string(from: myNumber)
            
            if let price = price {
                var priceValue = price
                if price.count > 1 {
                    priceValue = String(priceValue.dropFirst())
                }
              priceLbl.text = "$ \(priceValue)"
            }
        }
        
//        if let myInteger = Float(price!) {
//            let myNumber = NSNumber(value:myInteger)
//            let numberFormatter = NumberFormatter()
//           // numberFormatter.numberStyle = .currency
//            numberFormatter.numberStyle = NumberFormatter.Style.decimal
//            let price = numberFormatter.string(from: myNumber)
//            let myPrice = (price! as NSString).doubleValue
//            let strValue = String(format: "%.2f", myPrice)
//            priceLbl.text = "$ \(strValue)"
//           // priceLbl.text = "$ \(price!).00"
//        }
       // priceLbl.text = "$ \(price!)"
        
        
        addressLbl.text = model?.address
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func editButtonTapped(_ sender: Any)
    {
            let navController : UINavigationController  = storyboard?.instantiateViewController(withIdentifier: "SlidingNavigationController") as! UINavigationController
            let controller = storyboard?.instantiateViewController(withIdentifier: "AddPropertyViewController") as? AddPropertyViewController
            controller?.canAdd = false
            controller?.propertyModel = model
            navController.viewControllers = [controller!]
            frostedViewController.contentViewController = navController
    }
    
    @IBAction func deleteButtonTapped(_ sender: Any) 
    {
        showAlert("MyHomeBuy", "Do you really want to delete this Property?")
    }
    
    func showAlert(_ title : String , _ msg : String ){
        
        let alertController = UIAlertController(title: title, message: msg, preferredStyle: UIAlertControllerStyle.alert)
        
        let DestructiveAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: "nil"), style: .default) {
            (result : UIAlertAction) -> Void in
            print("Destructive")
        }
        
        let okAction = UIAlertAction(title: NSLocalizedString("OK", comment: "nil"), style: UIAlertActionStyle.default) {
            (result : UIAlertAction) -> Void in
            self.requestDeletePropertAPI()

            
            print("OK")
            
        }
        
        alertController.addAction(DestructiveAction)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
        alertController.view.tintColor = UIColor.black
        
    }
    @IBAction func menuBtnPressed(_ sender: Any) {
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
    
    @IBAction func agentNoButtonAction(_ sender: Any)
    {
        if let contact = model?.agent_contact {
            
            if let url = URL(string: "tel://\(contact)")  {
                if(contact == ""){
                    view.makeToast("No contact available")
                }else{
                    if UIApplication.shared.canOpenURL(url) {
                        if #available(iOS 10, *) {
                            UIApplication.shared.open(url)
                        } else {
                            UIApplication.shared.openURL(url)
                        }
                    }
                    else {
                        print("Your device doesn't support this feature.")
                        self.view.makeToast("Your device doesn't support this feature.")
                    }
                }
             
            }
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

extension PropertyDetailViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellHeight = (collectionView.frame.size.height)
        let cellWidth = (collectionView.frame.size.width)
        
        return CGSize(width : cellWidth , height : cellHeight)
    }
}


extension PropertyDetailViewController : UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let imageArray =  model?.image?.components(separatedBy: ",")
        return (imageArray?.count)!
        
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "PropertyDetailCollectionCell", for: indexPath) as! PropertyDetailCollectionCell
        let imageArray =  model?.image?.components(separatedBy: ",")
        
        let string = imageArray?[indexPath.row]
        cell.propertyImageView.sd_setImage(with: URL(string: string!), placeholderImage: UIImage.init(named: "add_home_placeholder"))
        return cell
        
    }
}

extension PropertyDetailViewController
{
    func requestDeletePropertAPI( ){
        //  {"id":"3","method_name":"delete_user_document"}
        //let userId = UserDefaults.standard.object(forKey: USER_ID) as! String
        // let id =  model?.id!
        let id  = (model?.id)!
        let parmDict = ["id" :id,"method_name" : ApiUrl.METHOD_DELETE_PROPERTY,"image" :"","tablename" : "user_property"] as [String : Any]
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        ApiManager.sharedInstance.apiCall(parmDict, [UIImage](), {(data) ->() in
            
            let dictionary = data as! NSDictionary
            
            let status = dictionary["status"] as? Int
            let msg = dictionary["msg"] as? String
            if(status == 1){
                //  self.pdfArray.remove(at: tag)
                //   self.pdfTableView.reloadData()
               // self.propertyTableView.reloadData()
                self.navigationController?.popViewController(animated: true)
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


