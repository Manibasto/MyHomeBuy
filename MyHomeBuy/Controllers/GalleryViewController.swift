//
//  GalleryViewController.swift
//  MyHomeBuy
//
//  Created by Vikas on 31/10/17.
//  Copyright © 2017 MobileCoderz. All rights reserved.
//

import UIKit
import MBProgressHUD
import Toast_Swift
class GalleryViewController: UIViewController {
    var dataModel = GalleryImagesBase(dictionary: ["" : ""] )
    var currenttag = -1
    
    @IBOutlet weak var navigationBarView: UIView!
    
    @IBOutlet weak var galleryCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        //navigationBarView.setBottomShadow()
        // Long Tap gesture
     //   addLongPressGesture()
        frostedViewController.panGestureEnabled = false
        requestGetAllPropertyImagesAPI()
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
    
    /*
    func addLongPressGesture() {
        let lpgr = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
       // lpgr.delegate = self
        lpgr.delaysTouchesBegan = true
        galleryCollectionView.addGestureRecognizer(lpgr)
        
    }
    func handleLongPress(_ gestureRecognizer : UILongPressGestureRecognizer)
    {
        if(gestureRecognizer.state != .ended){
            return
        }
        
        let p  = gestureRecognizer.location(in: galleryCollectionView)
        if  let indexPath = galleryCollectionView.indexPathForItem(at: p){
            showAlert("MyHomeBuy", "Do you really want to delete this image?")
              currenttag = indexPath.row
            // showAlert("MyHomeBuy", "Do you really want to delete this image?", DocumentType.Image)
        }
        
    }
    */
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
    @IBAction func homeBtnPressed(_ sender: Any) {
        let navController : UINavigationController  = storyboard?.instantiateViewController(withIdentifier: "SlidingNavigationController") as! UINavigationController
        var controller: UIViewController!
        
        controller = storyboard?.instantiateViewController(withIdentifier: "MyHomeViewController") as? MyHomeViewController
        
        navController.viewControllers = [controller]
        
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

extension GalleryViewController : UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (dataModel?.data?.count)!
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "GalleryCollectionCell", for: indexPath) as! GalleryCollectionCell
        cell.galleryImageView.clipsToBounds = true
        let model = dataModel?.data![indexPath.row]
        cell.galleryImageView.sd_setImage(with: URL(string: (model?.image)!))
        // Cross Button
         cell.crossButton.addTarget(self, action: #selector(crossButtonTapped(_:)), for: .touchUpInside)
        cell.crossButton.tag = indexPath.row
        return cell
        
    }
    
        func crossButtonTapped(_ button : UIButton){
            currenttag = button.tag

            showAlert("MyHomeBuy", "Do you really want to delete this image?")
            //requestDeletePropertAPI()
            //currenttag = indexPath.row
    //        let model = dataModel?.data?[button.tag]
    //
    //        let navController : UINavigationController  = storyboard?.instantiateViewController(withIdentifier: "SlidingNavigationController") as! UINavigationController
    //        let controller = storyboard?.instantiateViewController(withIdentifier: "AddPropertyViewController") as? AddPropertyViewController
    //        controller?.canAdd = false
    //        controller?.propertyModel = model
    //        navController.viewControllers = [controller!]
    //        frostedViewController.contentViewController = navController
       }
    
    
}
extension GalleryViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellSize = (collectionView.frame.size.width)/2
        print("collectionviewheightAndWidth  \(collectionView.frame.size.width)   \(cellSize)")
        return CGSize(width : cellSize , height : cellSize)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DocumentViewerViewController") as! DocumentViewerViewController
           vc.isFromGallery=true
        let model = dataModel?.data![indexPath.row]
        vc.galleryImageStr = (model?.image)!
//        let model = imageArray[indexPath.row]
//        vc.model = model
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
extension GalleryViewController{
    func requestGetAllPropertyImagesAPI(){
        //{"method_name":"get_allProperty_Image","user_id":"11"}
        
        let userId = UserDefaults.standard.object(forKey: USER_ID) as! String
        let parmDict = ["user_id" : userId ,"method_name" : ApiUrl.METHOD_GET_PROPERTY_IMAGES ] as [String : Any]
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        ApiManager.sharedInstance.requestApiServer(parmDict, [UIImage](), {(data) ->() in
            MBProgressHUD.hide(for: self.view, animated: true)
            self.responseOfGetAllPropertyImages(data)
        }, {(error)-> () in
            print("failure \(error)")
            MBProgressHUD.hide(for: self.view, animated: true)
            self.view.makeToast(NETWORK_ERROR)
        },{(progress)-> () in
            print("progress \(progress)")
            
        })
        
    }
    func responseOfGetAllPropertyImages(_ userData : Any){
        dataModel = GalleryImagesBase(dictionary: userData as! NSDictionary)
        if(dataModel?.status == 1){
            setupControllerData()
        }else{
            view.makeToast("No images available")
        }
        //self.view.makeToast((dataModel?.msg)!)
        
    }
    
    func setupControllerData(){
        if let count = dataModel?.data?.count{
            if(count > 0){
                galleryCollectionView.delegate = self
                galleryCollectionView.dataSource = self
                galleryCollectionView.reloadData()
            }
        }
        
        
    }
  
}
extension GalleryViewController
{
    func requestDeletePropertAPI(){
        //  {"id":"3","method_name":"delete_user_document"}
        let model = dataModel?.data![currenttag]
        //let id = model?.id
        let id  = (model?.id)!
        let image = (model?.image)!
        
        
        let parmDict = ["image_url" : image,"id" : id,"method_name" : ApiUrl.METHOD_DELETE_PROPERTY,"tablename" : "user_property"] as [String : Any]
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        ApiManager.sharedInstance.apiCall(parmDict, [UIImage](), {(data) ->() in
            
            let dictionary = data as! NSDictionary
            let status = dictionary["status"] as? Int
            let msg = dictionary["msg"] as? String
            if(status == 1){
             // self.dataModel?.data.remove(at: currenttag)
                self.dataModel?.data?.remove(at: self.currenttag)
                self.galleryCollectionView.reloadData()
                
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

