//
//  TaskContactViewController.swift
//  MyHomeBuy
//
//  Created by Vikas on 03/11/17.
//  Copyright © 2017 MobileCoderz. All rights reserved.
//

import UIKit
import MBProgressHUD
import SDWebImage
class TaskContactViewController: UIViewController {
    @IBOutlet weak var waterMarkLbl: UILabel!
    
    @IBOutlet weak var taskContactCollectionView: UICollectionView!
    @IBOutlet weak var taskContactLbl: UILabel!
    @IBOutlet weak var taskContactImageView: UIImageView!
    @IBOutlet weak var taskHeadingView: UIView!
    @IBOutlet weak var navigationBarView: UIView!
    var dataDict = NSDictionary()
    var currentTaskID = "-1"
    
    var dataModel = AddContactBase(dictionary: ["" : ""] )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        frostedViewController.panGestureEnabled = false
//        navigationBarView.setBottomShadow()
//        taskHeadingView.setBottomShadow()
        setupHeaderData()
       
        
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        navigationBarView.setBottomShadow()
        taskHeadingView.setBottomShadow()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        requestGetAllTaskContactAPI()

    }
    func setupHeaderData(){
        let image = UIImage.init(named: (dataDict.object(forKey: "image_white") as! String?)!)
        taskContactImageView.image = image
        let title = dataDict.object(forKey: "headerText") as! String?
        taskContactLbl.text = title
       
        
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
    
    @IBAction func addContactBtnPressed(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddEditTaskContactViewController") as! AddEditTaskContactViewController
        vc.dataDict = dataDict
        vc.currentTaskID = currentTaskID
        vc.currentScreen = AddEditTaskContactViewController.CurrentScreenType.ADD_SCREEN.rawValue
        vc.delegate = self
        vc.fromTask = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func requestServer() {
        dataModel?.data?.removeAll()
        taskContactCollectionView.reloadData()
        requestGetAllTaskContactAPI()
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

extension TaskContactViewController : UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = dataModel?.data?.count{
            return count
        }
        return 0
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = dataModel?.data?[indexPath.row]

        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "TaskContactCollectionCell", for: indexPath) as! TaskContactCollectionCell
        cell.borderView.setRadius(5)
        cell.profileView.setRadius(cell.profileView.frame.size.width/2)
        //cell.profileView.clipsToBounds = true
        //cell.contactImageView.setRadius(cell.profileView.frame.size.width/2)
        cell.initialLbl.text = model?.name?.getInitials("").uppercased()
        cell.nameLbl.text = model?.name
        cell.contactLbl.text = model?.phone_number
        cell.contactImageView.image = nil

        if(model?.image == ""){
            
        }else{
            cell.contactImageView.sd_setImage(with: URL(string: (model?.image)!)) { (image, error, cache, url) in
                // Your code inside completion block
//                if(image != nil){
//                    cell.initialLbl.text = ""
//                }
                
            }
        }
      
        
        return cell
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "TaskContactCollectionReusableFooterView", for: indexPath) as! TaskContactCollectionReusableFooterView
        
        let titleColor = footerView.addContactBtn.titleColor(for: .normal)
        footerView.addContactBtn.setRadius(10, titleColor!, 2)
        footerView.addContactBtn.addTarget(self, action: #selector(addContactBtnPressed(_:)), for: .touchUpInside)
        return footerView
    }
    
    
}

extension TaskContactViewController : UICollectionViewDelegate{

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ContactDetailViewController") as! ContactDetailViewController
        vc.dataDict = dataDict
      vc.model = dataModel?.data?[indexPath.row]
        vc.fromTask = true
        self.navigationController?.pushViewController(vc, animated: true)
        
    }

}
extension TaskContactViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellSize = (collectionView.frame.size.width)/2
        print("collectionviewheightAndWidth  \(collectionView.frame.size.width)   \(cellSize)")
        return CGSize(width : cellSize , height : 153)
    }
}
extension TaskContactViewController{
    func requestGetAllTaskContactAPI(){
        //{"method_name":"get_user_TaskContact","task_id":"2","user_id":"11"}
        
        
        
        let userId = UserDefaults.standard.object(forKey: USER_ID) as! String
        let parmDict = ["user_id" : userId ,"method_name" : ApiUrl.METHOD_GET_TASK_CONTACT , "task_id" : currentTaskID] as [String : Any]
        
     //   MBProgressHUD.showAdded(to: self.view, animated: true)
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
        
        dataModel = AddContactBase(dictionary: userData as! NSDictionary)
        if(dataModel?.status == 1){
            taskContactCollectionView.delegate = self
            taskContactCollectionView.dataSource  = self
            taskContactCollectionView.reloadData()
        
            if let count = dataModel?.data?.count{
                if(count == 0){
                    //self.waterMarkLbl.isHidden = false
                    self.view.makeToast("No contacts available")


                }else{
                  //  self.waterMarkLbl.isHidden = true

                }

            }

        }else{
            
            self.view.makeToast("No contacts available")
           // self.waterMarkLbl.isHidden = false
        }
    }
}
extension TaskContactViewController : ContactUpdatedDelegate{
    func contactUpdated() {

        requestServer()
    }

}
