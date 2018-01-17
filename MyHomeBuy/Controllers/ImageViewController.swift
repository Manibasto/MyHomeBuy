//
//  ImageViewController.swift
//  MyHomeBuy
//
//  Created by Santosh Rawani on 11/01/18.
//  Copyright © 2018 MobileCoderz. All rights reserved.
//

import UIKit
import MBProgressHUD
import SwiftyJSON
class ImageViewController: UIViewController {
    @IBOutlet weak var imageCollectionView: UICollectionView!
    var currentTaskID = "0"
    //var dataModel = ImageBase(dictionary: ["" : ""] )

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
    extension ImageViewController : UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
//        if let count  = dataModel?.data?.count {
//            return count
//        }
        return 0;
        //return 10;
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int
    {
      return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
   // let model = dataModel?.data?[indexPath.row]
    let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "DocumentCollectionCell", for: indexPath) as! DocumentCollectionCell
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
//    cell.contactImageView.sd_setImage(with: URL(string: (model?.image)!)) { (image, error, cache, url) in
//    // Your code inside completion block
//    //                if(image != nil){
//    //                    cell.initialLbl.text = ""
//    //                }
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
                self.navigationController?.pushViewController(vc, animated: true)
        }
    
    }



    extension ImageViewController : UICollectionViewDelegateFlowLayout {
        func collectionView(_ collectionView: UICollectionView,
                            layout collectionViewLayout: UICollectionViewLayout,
                            sizeForItemAt indexPath: IndexPath) -> CGSize {
            let cellSize = (collectionView.frame.size.width)/3
            print("collectionviewheightAndWidth  \(collectionView.frame.size.width)   \(cellSize)")
            return CGSize(width : self.imageCollectionView.frame.size.width/3 , height : self.imageCollectionView.frame.size.width/3)
        }
    }





