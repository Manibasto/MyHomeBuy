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
var imageArray = [UIImage]()



enum DocumentType {
    case Image
    case Pdf

}
class UploadDocumentVC: UIViewController {
    let  imagePicker =  UIImagePickerController()
    var currentDocumentType : DocumentType = .Image
    @IBOutlet weak var userImageView: UIImageView!
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
            requestAddImageAPI()
        }else{
           // mySpecialFunction()
            
            
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
}
extension UploadDocumentVC : UINavigationControllerDelegate
{
    
}

extension UploadDocumentVC : UIImagePickerControllerDelegate
{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
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
        let cico = url as URL
        print("The Url is : /(cico)")
        //optional, case PDF -> render
        //displayPDFweb.loadRequest(NSURLRequest(url: cico) as URLRequest)
 }
    
}

extension UploadDocumentVC
{
    func requestAddImageAPI(){
    //{"method_name":"add_user_Document","description","user_id":"5","task_id":"1","file_type:"image","file_name":"" }
        
        let userId = UserDefaults.standard.object(forKey: USER_ID) as! String
        
        let parmDict = ["user_id" : userId,"task_id" : SharedAppDelegate.currentTaskID,"file_type" : "image","method_name" : ApiUrl.METHOD_ADD_DOCUMENT] as [String : Any]
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        ApiManager.sharedInstance.requestDocumentImageApiServer(parmDict,imageArray, {(data) ->() in
         
            
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




