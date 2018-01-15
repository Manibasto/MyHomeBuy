//
//  UploadDocumentVC.swift
//  MyHomeBuy
//
//  Created by Santosh Rawani on 12/01/18.
//  Copyright © 2018 MobileCoderz. All rights reserved.
//

import UIKit

class UploadDocumentVC: UIViewController {
    let  imagePicker =  UIImagePickerController()
    @IBOutlet weak var userImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
    }
    
    @IBAction func selectFileBtnAction(_ sender: Any)
    {
        cameraBtnPressed()
    }
    
    @IBAction func cancelBtnAction(_ sender: Any) {
    }
    @IBAction func uploadBtnAction(_ sender: Any) {
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
       // imageArray.removeAll()
        imagePicker.allowsEditing = true
        imagePicker.dismiss(animated: true, completion: nil)
        userImageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        let capturedImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        guard let image = capturedImage else{return}
        let size = CGSize(width: 200, height: 200)
        guard let finalImage = image.resize(size, 0.5) else{return}
      //  imageArray.append(finalImage)
    }
    
}
