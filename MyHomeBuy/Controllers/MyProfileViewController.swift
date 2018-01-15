//
//  MyProfileViewController.swift
//  MyHomeBuy
//
//  Created by Vikas on 05/10/17.
//  Copyright © 2017 MobileCoderz. All rights reserved.
//

import UIKit
import SDWebImage
import MBProgressHUD
class MyProfileViewController: UIViewController {
    @IBOutlet weak var navigationBarView: UIView!
    
    @IBOutlet weak var prifileBgView: UIView!
    @IBOutlet weak var editProfileView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var bgProfileImageView: UIImageView!
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var bgProfileView: UIView!
    @IBOutlet weak var changePinBtn: UIButton!
    @IBOutlet weak var contactLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    
    @IBOutlet weak var milestoneLbl: UILabel!
    
    @IBOutlet weak var propertiesLbl: UILabel!
   
    @IBOutlet weak var noOfContactsLbl: UILabel!
    var dataModel = DetailBase(dictionary: ["" : ""] )

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupUI()
        requestDataAPI()
        //profileBtn.sd_setBackgroundImage(with: URL(string : url), for: .normal, placeholderImage:UIImage(named: "camera.png"))
        navigationBarView.setBottomShadow()

        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        frostedViewController.panGestureEnabled = true
        setupdata()
    }
    func setupdata(){
        if let username = UserDefaults.standard.object(forKey: USER_NAME){
            nameLbl.text = username as? String
            
        }
        if let address = UserDefaults.standard.object(forKey: USER_ADDRESS){
            addressLbl.text = address as? String
        }
        if let userEmail = UserDefaults.standard.object(forKey: USER_EMAIL){
            emailLbl.text = userEmail as? String
        }
        
        if let userPhone = UserDefaults.standard.object(forKey: USER_CONTACT_NUMBER){
            contactLbl.text = userPhone as? String
        }
        if let userImage = UserDefaults.standard.object(forKey: USER_IMAGE){
            let url = userImage as? String
            profileImageView.sd_setImage(with: URL(string: url!), placeholderImage: UIImage(named: "user_icon"))
            bgProfileImageView.sd_setImage(with: URL(string: url!), placeholderImage: UIImage(named: "user_icon"))
        }
        let userPin = UserDefaults.standard.object(forKey: USER_PIN) as! String
        if(userPin == ""){
            changePinBtn.setTitle("GENERATE PIN NUMBER", for: .normal)
            
        }else{
            changePinBtn.setTitle("CHANGE PIN NUMBER", for: .normal)
        }
    }
    func setupUI(){
        editProfileView.setRadius(editProfileView.frame.size.width/2)
        prifileBgView.setRadius(prifileBgView.frame.size.width/2, .lightGray)
        //changePinBtn.setRadius(10, .lightBlue)
        changePinBtn.setRadius(10, .lightBlue, 2)

        bgProfileView.setRadius(5)
        bgView.setRadius(5)
        
       
        milestoneLbl.text = "0/7"
        noOfContactsLbl.text = "0"
        propertiesLbl.text = "0"
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    @IBAction func changePinBtnPressed(_ sender: Any) {
        
        
        let userPin = UserDefaults.standard.object(forKey: USER_PIN) as! String
        if(userPin == ""){
            openGeneratePinVC()
            
        }else{
           openChangePinVC()
        }

      
        
        
        //
        //        let changePinVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ChangePinViewController") as! ChangePinViewController
        //        self.navigationController?.pushViewController(changePinVC, animated: true)
    }
    func openGeneratePinVC(){
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "GeneratePinViewController") as! GeneratePinViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func openChangePinVC(){
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ChangePinViewController") as! ChangePinViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func editProfileBtnPressed(_ sender: Any) {
        let editProfileVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EditProfileViewController") as! EditProfileViewController
        self.navigationController?.pushViewController(editProfileVC, animated: true)
    }
    
    @IBAction func menuBtnPressed(_ sender: Any) {
        if let navCon = navigationController{
            navCon.popViewController(animated: true)
        }    }
}

extension MyProfileViewController{
    func requestDataAPI(){
        // Api Request : {"method_name":"user_status_count","user_id":"84"}
       // Api Response : {"status":1,"msg":"Successfully","data":{"total_milestone":0,"total_property":8,"total_contact":1}}
        
        let userId = UserDefaults.standard.object(forKey: USER_ID) as! String
        let parmDict = ["user_id" : userId ,"method_name" : ApiUrl.METHOD_DETAILS ] as [String : Any]
        
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
    
    func responseWithSuccess(_ userData : Any ){
        dataModel = DetailBase(dictionary: userData as! NSDictionary)
        if(dataModel?.status == 1){
            let milestone = dataModel?.data?.total_milestone
             let contacts = dataModel?.data?.total_contact
             let property = dataModel?.data?.total_property
            milestoneLbl.text = "\(milestone!)/7"
            noOfContactsLbl.text = "\(contacts!)"
            propertiesLbl.text = "\(property!)"
        }else{
            view.makeToast((dataModel?.msg)!)
            
        }
        
    }
}
