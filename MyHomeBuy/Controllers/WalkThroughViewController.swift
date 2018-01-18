//
//  WalkThroughViewController.swift
//  MyHomeBuy
//
//  Created by Vikas on 04/10/17.
//  Copyright © 2017 MobileCoderz. All rights reserved.
//

import UIKit

class WalkThroughViewController: UIViewController {
    
    @IBOutlet var dotImageViewArray: [UIImageView]!
   
    @IBOutlet weak var skipIntroLbl: UILabel!
    @IBOutlet weak var headerLbl: UILabel!
  
    @IBOutlet weak var footerLbl: UILabel!
    @IBOutlet weak var introCollectionView: UICollectionView!
    var dataArray = [Any]()
    @IBOutlet weak var skipIntroBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        skipIntroBtn.setRadius(5)
        initData()
        introCollectionView.delegate  = self
        introCollectionView.dataSource = self
        let dict = dataArray[0] as! NSDictionary
        headerLbl.text = dict.object(forKey: "header") as! String?
        footerLbl.text = dict.object(forKey: "footer") as! String?
        
    }
    func initData(){
        let data1 = ["header" : "Let's get you started using\nMyHomeBuy" , "footer" : "With tips and tasks to help you during your buying process" , "image" : "slider_1"]
       let data2 = ["header" : "Keep on track of your buying process journey" , "footer" : "Start with Milestone 1 and follow the steps" , "image" : "graph_image"]
        let data3 = ["header" : "Personalise your buying process " , "footer" : "Add your own tasks and set reminders" , "image" : "slider_3"]
        let data4 = ["header" : "Store and keep track of your properties" , "footer" : "Setup property profiles, save details and add photos" , "image" : "slider_4"]
        dataArray.append(data1)
        dataArray.append(data2)
        dataArray.append(data3)
        dataArray.append(data4)
        for (index , imageView) in dotImageViewArray.enumerated() {
            if (index == 0){
            imageView.image = UIImage.init(named: "slider_selected")
            }else{
            imageView.image = UIImage.init(named: "slider_normal")
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func skipIntroBtnPressed(_ sender: Any) {
//            let signupVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EnterPinViewController") as! EnterPinViewController
//            self.navigationController?.pushViewController(signupVC, animated: true)
        let slidingRootController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SlidingRootViewController") as! SlidingRootViewController
        self.navigationController?.pushViewController(slidingRootController, animated: true)
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        let pageWidth = scrollView.frame.width
        let currentPage = Int((scrollView.contentOffset.x + pageWidth / 2) / pageWidth)
        print("currentPage  \(currentPage)")
        updateDots(currentPage)
    }
    func updateDots(_ currentIndex : Int){
        for (index , imageView) in dotImageViewArray.enumerated() {
            if (index == currentIndex){
                imageView.image = UIImage.init(named: "slider_selected")
            }else{
                imageView.image = UIImage.init(named: "slider_normal")
            }
        }
        let dict = dataArray[currentIndex] as! NSDictionary
        headerLbl.text = dict.object(forKey: "header") as! String?
        
        footerLbl.text = dict.object(forKey: "footer") as! String?
        if(currentIndex == dataArray.count-1){
            skipIntroLbl.text = "DONE"

        }else{
        skipIntroLbl.text = "SKIP INTRO"
        }
    }
   
}

extension WalkThroughViewController : UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let dict = dataArray[indexPath.row] as! NSDictionary
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "WalkThroughCollectionCell", for: indexPath) as! WalkThroughCollectionCell
     //cell.topLbl.text = dict.object(forKey: "header") as! String?
      //  cell.bottomLbl.text = dict.object(forKey: "footer") as! String?
       let imageName =  dict.object(forKey: "image") as! String?
        cell.image.image = UIImage.init(named: imageName!)

        //cell.topLbl.text = dict.object(forKey: "header") as! String?

        //cell.bottomLbl.text = dict.object(forKey: "footer") as! String?
        return cell
        
    }
}
extension WalkThroughViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = collectionView.frame.size.width
        let cellheight = collectionView.frame.size.height

        //print("collectionviewhieghtAndWidth  \(collectionView.frame.size.width)   \(cellSize)")
        return CGSize(width : cellWidth , height : cellheight)
    }
}
