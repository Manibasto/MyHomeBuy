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
    
    @IBOutlet weak var navigationBarView: UIView!
    @IBOutlet weak var galleryCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        //navigationBarView.setBottomShadow()
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
        return (dataModel?.data?.URLArray.count)!
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "GalleryCollectionCell", for: indexPath) as! GalleryCollectionCell
        cell.galleryImageView.clipsToBounds = true
        let url = dataModel?.data?.URLArray[indexPath.row]
        cell.galleryImageView.sd_setImage(with: URL(string: url!)) { (image, error, cache, url) in
            
            
        }
        return cell
        
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
        if let count = dataModel?.data?.URLArray.count{
            if(count > 0){
                galleryCollectionView.delegate = self
                galleryCollectionView.dataSource = self
                galleryCollectionView.reloadData()
            }
        }
        
        
    }
}

