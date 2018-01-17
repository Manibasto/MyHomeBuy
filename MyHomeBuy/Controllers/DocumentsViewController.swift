//
//  DocumentsViewController.swift
//  MyHomeBuy
//
//  Created by Santosh Rawani on 11/01/18.
//  Copyright © 2018 MobileCoderz. All rights reserved.
//

import UIKit
import MBProgressHUD
import SwiftyJSON
import SDWebImage

class DocumentsViewController: UIViewController {
    
   
    @IBOutlet weak var imageCollectionView: UICollectionView!
    @IBOutlet weak var pdfTableView: UITableView!

    @IBOutlet weak var taskDocumentLbl: UILabel!
    @IBOutlet weak var taskDocumentImageView: UIImageView!
    @IBOutlet weak var taskHeadingView: UIView!
    @IBOutlet weak var navigationBarView: UIView!
    @IBOutlet weak var headingHeightConstraint: NSLayoutConstraint!

    @IBOutlet weak var imageLineLabel: UILabel!
    @IBOutlet weak var pdfLineLabel: UILabel!
    @IBOutlet weak var imageBtn: UIButton!
    
    @IBOutlet weak var pdfBtn: UIButton!
    @IBOutlet weak var addPdfBtn: UIButton!
    @IBOutlet var footerView: UIView!

    var currentTaskID = "0"
    var dataDict = NSDictionary()
    var fromTask = false
    var imageArray = [DocumentModel]()
    var pdfArray = [DocumentModel]()
    var dataModel = DocumentBase(dictionary: ["" : ""] )



    override func viewDidLoad() {
        super.viewDidLoad()
        pdfLineLabel.isHidden=true
        imageLineLabel.isHidden=false;
        imageCollectionView.delegate=self
        imageCollectionView.dataSource=self
        pdfTableView.delegate=self
        pdfTableView.dataSource=self
        addFooterView()
        // Do any additional setup after loading the view.
        if(fromTask){
            setupHeaderData()
            taskDocumentLbl.isHidden = false

        }else{
            headingHeightConstraint.constant = 0
            taskDocumentLbl.isHidden = true
        }
        updateView(show: 1)
        
        // Long Tap gesture
      //  let lpgr = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        
      
    }
//    func handleLongPress(gestureRecognizer : UILongPressGestureRecognizer){
//
//        if (gestureRecognizer.state != UIGestureRecognizerState.ended){
//            return
//        }
//
//        let p = gestureRecognizer.location(in: self.imageCollectionView)
//
//        if let indexPath : NSIndexPath = (self.imageCollectionView?.indexPathForItem(at: p))! as NSIndexPath{
//            //do whatever you need to do
//        }
//
//    }

    func setupHeaderData(){
        let image = UIImage.init(named: (dataDict.object(forKey: "image_white") as! String?)!)
        taskDocumentImageView.image = image
        let title = dataDict.object(forKey: "headerText") as! String?
        taskDocumentLbl.text = title
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        requestGetDocumentAPI()

    }
    override func viewWillLayoutSubviews()
    {
        super.viewWillLayoutSubviews()
        navigationBarView.setBottomShadow()
        taskHeadingView.setBottomShadow()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backBtnPressed(_ sender: Any)
    {
        if let navCon = navigationController
        {
            navCon.popViewController(animated: true)
        }
        
    }
    func addFooterView(){
        footerView.frame(forAlignmentRect: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 111))
        pdfTableView.tableFooterView = footerView
        let titleColor = addPdfBtn.titleColor(for: .normal)
        addPdfBtn.setRadius(10, titleColor!, 2)
        addPdfBtn.addTarget(self, action: #selector(addPdfBtnTapped(_:)), for: .touchUpInside)
    }
    func addPdfBtnTapped(_ button : UIButton)
    {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "UploadDocumentVC") as! UploadDocumentVC
        vc.currentDocumentType = .Pdf
        vc.currentTaskID = currentTaskID
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func imageButtonAction(_ sender: Any)
    {
           imageBtn.setTitleColor(UIColor.white, for: .normal)
           pdfBtn.setTitleColor(UIColor.lightWhite, for: .normal)
           imageLineLabel.isHidden=false
           pdfLineLabel.isHidden=true
           updateView(show: 1)
   }
   
    @IBAction func pdfButtonAction(_ sender: Any)
    {
        imageBtn.setTitleColor(UIColor.lightWhite, for: .normal)
        pdfBtn.setTitleColor(UIColor.white, for: .normal)
        imageLineLabel.isHidden=true
        pdfLineLabel.isHidden=false
        updateView(show: 0)
    }
    func updateView(show : Int){
        if(show == 1){
            pdfTableView.isHidden = true
            imageCollectionView.isHidden = false

        }else{
            pdfTableView.isHidden = false
            imageCollectionView.isHidden = true
        }
        
    }
}
 
extension DocumentsViewController
{
    func requestGetDocumentAPI(){
   // {"user_id":"5","method_name":"get_user_document","task_id":"1"}
        let userId = UserDefaults.standard.object(forKey: USER_ID) as! String

        let parmDict = ["user_id" : userId,"task_id" : currentTaskID,"method_name" : ApiUrl.METHOD_GET_DOCUMENT] as [String : Any]
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        ApiManager.sharedInstance.requestApiServer(parmDict, [UIImage](), {(data) ->() in
            self.responseWithSuccess(data)
            
            MBProgressHUD.hide(for: self.view, animated: true)
        }, {(error)-> () in
            print("failure \(error)")
            MBProgressHUD.hide(for: self.view, animated: true)
            self.view.makeToast(NETWORK_ERROR)
            
            
        },{(progress)-> () in
            print("progress \(progress)")
            
        })
        
    }
    
    func responseWithSuccess(_ userData : Any){
        
        dataModel = DocumentBase(dictionary: userData as! NSDictionary)
        if(dataModel?.status == 1){
            pdfArray.removeAll()
            imageArray.removeAll()
            for data in  (dataModel?.data)!{
                if(data.file_type == "image")
                {
                    imageArray.append(data)
                }
                else
                {
                    pdfArray.append(data)
                }
                
            }
            imageCollectionView.reloadData()
            pdfTableView.reloadData()
        }else
        {
            self.view.makeToast("Unable to fetch data")
        }
    }
}




extension DocumentsViewController : UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
      
     //   return 2;
//        if let count  = dataModel?.data?.count {
//                       return count
//                  }
        return imageArray.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = imageArray[indexPath.row]
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "DocumentCollectionCell", for: indexPath) as! DocumentCollectionCell
        
        
        //let url = dataModel?.data?.URLArray[indexPath.row]
        //cell.userImageView.sd_setImage(with: URL(string: url!)) { (image, error, cache, url) in
        // cell.borderView.setRadius(5)
        // cell.profileView.setRadius(cell.profileView.frame.size.width/2)
        //cell.profileView.clipsToBounds = true
        //cell.contactImageView.setRadius(cell.profileView.frame.size.width/2)
        //    cell.initialLbl.text = model?.name?.getInitials("").uppercased()
        //    cell.nameLbl.text = model?.name
        //    cell.contactLbl.text = model?.phone_number
        //  cell.contactImageView.image = nil
        //    if(model?.image == ""){
        //
        //    }else{
          cell.userImageView.sd_setImage(with: URL(string: model.file_name!))
            // Your code inside completion block
            //                if(image != nil){
            //                    cell.initialLbl.text = ""
            //                }
        //
        //    }
        //}
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "ImageDocumentCollectionReusableFooterView", for: indexPath) as! ImageDocumentCollectionReusableFooterView
        
        let titleColor = footerView.addANewImageBtn.titleColor(for: .normal)
        footerView.addANewImageBtn.setRadius(10, titleColor!, 2)
        footerView.addANewImageBtn.addTarget(self, action: #selector(addANewImageBtnTapped(_:)), for: .touchUpInside)
        //cell.taskCompleteBtn.addTarget(self, action: #selector(taskCompletedBtnPapped(_:)), for: .touchUpInside)
        return footerView
    }
    
    func addANewImageBtnTapped(_ button : UIButton)
    {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "UploadDocumentVC") as! UploadDocumentVC
         vc.currentTaskID = currentTaskID
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}


extension DocumentsViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellSize = (collectionView.frame.size.width)/3
        print("collectionviewheightAndWidth  \(collectionView.frame.size.width)   \(cellSize)")
        return CGSize(width : self.imageCollectionView.frame.size.width/3 , height : self.imageCollectionView.frame.size.width/3)
    }
}
extension DocumentsViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return (dataModel?.data?.count)!
        return pdfArray.count

        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = pdfArray[indexPath.row]

        let cell = tableView.dequeueReusableCell(withIdentifier: "pdfTableCell", for: indexPath) as! pdfTableCell;
         // cell.pdfDeleteBtn.addTarget(self, action: #selector(addContactBtnPressed(_:)), for: .touchUpInside)
        cell.pdfDeleteBtn.addTarget(self, action: #selector(pdfDeleteBtnTapped(_:)), for: .touchUpInside)
        cell.pdfDeleteBtn.tag = indexPath.row

        // [cell.yourbutton addTarget:self action:@selector(yourButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        if (indexPath.row % 2 == 0) {
            cell.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1.0)
        }else{
            cell.backgroundColor = UIColor.white // set your default color
        }
        
        return cell
    }
    func pdfDeleteBtnTapped(_ button : UIButton)
    {
        let model = pdfArray[button.tag]
       // deleteDocumentAPI(model.id!)
        deleteDocumentAPI(button.tag, model.id!)
    }
    
}
extension DocumentsViewController : UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 100
    }
    
    
}
extension DocumentsViewController
{
    func deleteDocumentAPI(_ tag : Int , _ id : String){
        // {"user_id":"5","method_name":"get_user_document","task_id":"1"}
        let userId = UserDefaults.standard.object(forKey: USER_ID) as! String
        
        let parmDict = ["user_id" : userId,"id" : index,"method_name" : ApiUrl.METHOD_DELETE_DOCUMENT] as [String : Any]
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        ApiManager.sharedInstance.requestApiServer(parmDict, [UIImage](), {(data) ->() in
            
            MBProgressHUD.hide(for: self.view, animated: true)
        }, {(error)-> () in
            print("failure \(error)")
            MBProgressHUD.hide(for: self.view, animated: true)
            self.view.makeToast(NETWORK_ERROR)
            self.pdfArray.remove(at: tag)
            self.pdfTableView.reloadData()
            
        },{(progress)-> () in
            print("progress \(progress)")
            
        })
        
}
}
