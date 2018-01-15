//
//  ResourceContactViewController.swift
//  MyHomeBuy
//
//  Created by Vikas on 07/11/17.
//  Copyright © 2017 MobileCoderz. All rights reserved.
//

import UIKit
import MBProgressHUD
import Toast_Swift
class ResourceContactViewController: UIViewController {

    @IBOutlet weak var contactTableView: UITableView!
    @IBOutlet weak var navigationBarView: UIView!
    @IBOutlet weak var addContactBtn: UIButton!
    var dataModel = AddContactBase(dictionary: ["" : ""] )
    var sectionIndexArray = [String]()
    var allContacts = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let titleColor = addContactBtn.titleColor(for: .normal)
        addContactBtn.setRadius(10, titleColor!, 2)
        FetchContacts.sharedInstance.delegate = self
        FetchContacts.sharedInstance.getContact()
        //navigationBarView.setBottomShadow()
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        navigationBarView.setBottomShadow()
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
    
    @IBAction func addContactPressed(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddEditTaskContactViewController") as! AddEditTaskContactViewController
        vc.currentScreen = AddEditTaskContactViewController.CurrentScreenType.ADD_SCREEN.rawValue
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func requestServer(){
    
        dataModel?.data?.removeAll()
        contactTableView.reloadData()
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

extension ResourceContactViewController{
    func requestGetAllTaskContactAPI(){
        //{"method_name":"get_user_TaskContact","task_id":"2","user_id":"11"}
        
        
        
        let userId = UserDefaults.standard.object(forKey: USER_ID) as! String
        let parmDict = ["user_id" : userId ,"method_name" : ApiUrl.METHOD_GET_TASK_CONTACT ] as [String : Any]
        
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
        
        dataModel = AddContactBase(dictionary: userData as! NSDictionary)
        if(dataModel?.status == 1){
            var values = Set<String>()
            sectionIndexArray.removeAll()
            for model in (dataModel?.data)! {
                if(allContacts.contains(model.phone_number!)){
                model.status = "1"
                }else{
                    model.status = "0"

                }
               let name =  model.name
                if let firstChar = name?.characters.first?.description{
                values.insert(firstChar.uppercased())
                }
            }
            
            for str in values {
                sectionIndexArray.append(str)
            }
            sectionIndexArray.sort()
            contactTableView.delegate = self
            contactTableView.dataSource  = self
            contactTableView.rowHeight = UITableViewAutomaticDimension
            contactTableView.estimatedRowHeight = 50
            contactTableView.reloadData()
            if(dataModel?.data?.count == 0){
            self.view.makeToast("No contacts available")

            }
        }else{
            
            self.view.makeToast("No contacts available")
        }
    }
}

extension ResourceContactViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (dataModel?.data?.count)!
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ResourceContactTableCell", for: indexPath) as! ResourceContactTableCell;
        let model = dataModel?.data?[indexPath.row]

        cell.profileView.setRadius(cell.profileView.frame.size.width/2)
      
        cell.initialLbl.text = model?.name?.getInitials("").uppercased()
        cell.nameLbl.text = model?.name
        cell.phoneLbl.text = model?.phone_number
        cell.profileImageView.image = nil
        if(model?.status == "1"){
        cell.contactAvailableImageView.isHidden = false
        }else{
            cell.contactAvailableImageView.isHidden = true

        }
        if(model?.image == ""){
            
        }else{
            cell.profileImageView.sd_setImage(with: URL(string: (model?.image)!)) { (image, error, cache, url) in
               
                
            }
        }
        
        
        return cell
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
    return sectionIndexArray
    }
    
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        
        return sectionIndexArray.count
    }
}
extension ResourceContactViewController : UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ContactDetailViewController") as! ContactDetailViewController
        vc.model = dataModel?.data?[indexPath.row]
        vc.fromTask = false
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
  
}
extension ResourceContactViewController : ContactUpdatedDelegate{
    func contactUpdated() {
        requestServer()
    }
    
}

extension ResourceContactViewController : GetPhoneNumbers{
    func getAllContact(contactArray: [String]) {
        print(contactArray)
        allContacts = contactArray
        DispatchQueue.main.async {
            self.requestGetAllTaskContactAPI()

        }

    }
    
}
