//
//  UploadDocumentVC.swift
//  MyHomeBuy
//
//  Created by Santosh Rawani on 12/01/18.
//  Copyright © 2018 MobileCoderz. All rights reserved.
//

import UIKit
import MobileCoreServices
import MBProgressHUD
import SwiftyJSON



enum DocumentType
{
    case Image
    case Pdf
}
class UploadDocumentVC: UIViewController {
    let  imagePicker =  UIImagePickerController()
    var currentDocumentType : DocumentType = .Image
    var currentTaskID = "0"
    var pdfData = Data()
    var imageArray = [UIImage]()
    var canUpload = false


    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var uploadBtn: UIButton!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var fileNameLabel: UILabel!
    override func viewDidLoad()
    {
        super.viewDidLoad()
       fileNameLabel.text = ""
       // userImageView.image  = nil
        // Do any additional setup after loading the view.
        
        if(currentDocumentType == .Image){
            self.userImageView.image = UIImage(named: "uploadDocuments")
        }
        else{
            self.userImageView.image = UIImage(named: "pdf")
        }
        cancelBtn.setRadius(5)
        uploadBtn.setRadius(5)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backButtonAction(_ sender: Any)
    {
        if let navCon = navigationController
        {
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
    func mySpecialFunction(){
        
        let importMenu = UIDocumentMenuViewController(documentTypes: [String(kUTTypePDF)], in: .import)
        importMenu.delegate = self
        importMenu.modalPresentationStyle = .formSheet
        self.present(importMenu, animated: true, completion: nil)
    }
    @IBAction func selectFileBtnAction(_ sender: Any)
    {
        if(currentDocumentType == .Image)
        {
             cameraBtnPressed()

        }else{
            mySpecialFunction()
        }
    }
    
    @IBAction func cancelBtnAction(_ sender: Any)
    {
        if let navCon = navigationController
        {
            navCon.popViewController(animated: true)
        }
    }
    @IBAction func uploadBtnAction(_ sender: Any)
    {
       
        
        if(currentDocumentType == .Image)
        {
            if(canUpload){
            requestAddImageAPI()
            }else{
                showAlert("MyHomeBuy", "Please select a file")

            }
        }else if (currentDocumentType == .Pdf){
           // mySpecialFunction()
            if(canUpload){

            requestAddPdfAPI()

            }else{
                showAlert("MyHomeBuy", "Please select a file")

            }
            
        }
       
    }
     func cameraBtnPressed() {
        let actionSheetController = UIAlertController(title: NSLocalizedString("Capture Photo", comment: "nil"), message: "", preferredStyle: .actionSheet)
        
        let cancelActionButton = UIAlertAction(title: NSLocalizedString("Cancel", comment: "nil"), style: .cancel) { action -> Void in
            print("Cancel")
        }
        actionSheetController.addAction(cancelActionButton)
        
        let saveActionButton = UIAlertAction(title: NSLocalizedString("Camera", comment: "nil"), style: .default) { action -> Void in
            print("Camera")
            self.capturePhotoFromCamera()
        }
        actionSheetController.addAction(saveActionButton)
        
        let deleteActionButton = UIAlertAction(title: NSLocalizedString("Gallery", comment: "nil"), style: .default) { action -> Void in
            print("Gallery")
            self.capturePhotoFromLibrary()
        }
        actionSheetController.addAction(deleteActionButton)
        self.present(actionSheetController, animated: true, completion: nil)
    }
    func capturePhotoFromCamera(){
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            present(imagePicker, animated: true, completion: nil)
        }else{
            self.view.makeToast(CAMERA_ERROR)
        }
    }
    func capturePhotoFromLibrary(){
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    func showAlert(_ title : String , _ msg : String){
        
        let alertController = UIAlertController(title: title, message: msg, preferredStyle: UIAlertControllerStyle.alert)
        
//        let DestructiveAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: "nil"), style: .default) {
//            (result : UIAlertAction) -> Void in
//            print("Destructive")
//        }
        
        
        let okAction = UIAlertAction(title: NSLocalizedString("OK", comment: "nil"), style: UIAlertActionStyle.default) {
            (result : UIAlertAction) -> Void in
            print("OK")
        }
        
        //alertController.addAction(DestructiveAction)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
        alertController.view.tintColor = UIColor.black
        
    }
}


extension UploadDocumentVC : UINavigationControllerDelegate
{
    
}

extension UploadDocumentVC : UIImagePickerControllerDelegate
{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        canUpload  = true
       imageArray.removeAll()
        imagePicker.allowsEditing = true
        imagePicker.dismiss(animated: true, completion: nil)
        userImageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        let capturedImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        guard let image = capturedImage else{return}
        let size = CGSize(width: 200, height: 200)
        guard let finalImage = image.resize(size, 0.5) else{return}
         imageArray.append(finalImage)
    }
    
}


extension UploadDocumentVC : UIDocumentMenuDelegate
{
    @available(iOS 8.0, *)
    public func documentMenu(_ documentMenu:     UIDocumentMenuViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController) {
        documentPicker.delegate = self
        present(documentPicker, animated: true, completion: nil)
        
    }
    
}
extension UploadDocumentVC : UIDocumentPickerDelegate{
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        
        print("we cancelled")
        
        dismiss(animated: true, completion: nil)
}
    @available(iOS 8.0, *)
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL)
    {
        //userImageView.image = UIImage(named: "pdf_file")

        let cico = url as URL
        print("The Url is : \(cico)")
       let pathComponenet = url.pathComponents
       let fileName = pathComponenet.last
        fileNameLabel.text = fileName

        //optional, case PDF -> render
        //displayPDFweb.loadRequest(NSURLRequest(url: cico) as URLRequest)
         pdfData = try! Data.init(contentsOf: cico)
         canUpload = true

 }
    
}

extension UploadDocumentVC
{
    func requestAddImageAPI(){
    //{"method_name":"add_user_Document","description","user_id":"5","task_id":"1","file_type:"image","file_name":"" }
        
        let userId = UserDefaults.standard.object(forKey: USER_ID) as! String
        
        let parmDict = ["user_id" : userId,"task_id" : currentTaskID,"file_type" : "image","method_name" : ApiUrl.METHOD_ADD_DOCUMENT] as [String : Any]
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        ApiManager.sharedInstance.requestDocumentImageApiServer(parmDict,imageArray, {(data) ->() in
            let dictionary = data as! NSDictionary
            
            let status = dictionary["status"] as? Int
            let msg = dictionary["msg"] as? String
            if(status == 1){
                self.view.makeToast("Add Image Successfully")
                self.canUpload = false
                //self.userImageView.image  = nil
                self.userImageView.image = UIImage(named: "uploadDocuments")
                if let navCon = self.navigationController
                {
                    navCon.popViewController(animated: true)
                }

                

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

extension UploadDocumentVC
{
    func requestAddPdfAPI(){
        //{"method_name":"add_user_Document","description","user_id":"5","task_id":"1","file_type:"image","file_name":"" }
        
        let userId = UserDefaults.standard.object(forKey: USER_ID) as! String
        let parmDict = ["user_id" : userId,"task_id" : currentTaskID,"file_type" : "pdf","method_name" : ApiUrl.METHOD_ADD_DOCUMENT] as [String : Any]
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        ApiManager.sharedInstance.requestDocumentPdfApiServer(parmDict,pdfData, {(data) ->() in
            
            let dictionary = data as! NSDictionary
            let status = dictionary["status"] as? Int
            let msg = dictionary["msg"] as? String
            if(status == 1){
                self.fileNameLabel.text = ""
                self.view.makeToast("Add Document Successfully")
                self.canUpload = false
              //  self.userImageView.image  = nil
                self.userImageView.image = UIImage(named: "pdf")
                if let navCon = self.navigationController
                {
                    navCon.popViewController(animated: true)
                }


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


