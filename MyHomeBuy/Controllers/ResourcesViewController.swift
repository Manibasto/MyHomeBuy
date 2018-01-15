//
//  ResourcesViewController.swift
//  MyHomeBuy
//
//  Created by Vikas on 27/10/17.
//  Copyright © 2017 MobileCoderz. All rights reserved.
//

import UIKit

class ResourcesViewController: UIViewController {

    var dataArray = [Any]()
    
    @IBOutlet weak var navigationBarView: UIView!
    @IBOutlet weak var mileStoneTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        initData()
        mileStoneTableView.delegate  = self
        mileStoneTableView.dataSource = self
       // navigationBarView.setBottomShadow()
        mileStoneTableView.tableFooterView = UIView()

    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        navigationBarView.setBottomShadow()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        frostedViewController.panGestureEnabled = true
    }
    func initData(){
        //let data1 = ["image" : "calculator_res"  , "text" : "MORTAGAGE CALCULATOR"] as [String : Any]
        let data2 = ["image" : "contacts_res"  , "text" : "Contacts"] as [String : Any]
        let data3 = ["image" : "calendar_res" ,  "text" : "Calender"] as [String : Any]
        let data4 = ["image" : "gallery_res"  , "text" : "Gallery"] as [String : Any]
        let data5 = ["image" : "notes_res" , "text" : "Notes"] as [String : Any]
        let data6 = ["image" : "main_documents_icon" , "text" : "Documents"] as [String : Any]

        
        //dataArray.append(data1)
        dataArray.append(data2)
        dataArray.append(data3)
        dataArray.append(data4)
        dataArray.append(data5)
        dataArray.append(data6)
       
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func menuBtnPressed(_ sender: Any) {
        frostedViewController.presentMenuViewController()
        
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

extension ResourcesViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count;
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dict = dataArray[indexPath.row] as! NSDictionary
        let cell = tableView.dequeueReusableCell(withIdentifier: "MainMileStoneTableCell", for: indexPath) as! MainMileStoneTableCell;
        cell.headingBtn.isUserInteractionEnabled = false
        let image = UIImage.init(named: (dict.object(forKey: "image") as! String?)!)
        cell.headingBtn.setImage(image, for: .normal)
        let title = dict.object(forKey: "text") as! String?
        cell.headingBtn.setTitle("  \(title!)", for: .normal)
        return cell
    }
}
extension ResourcesViewController : UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
//        case 0:
//            switchToMortagageCalculator()
//            break
            case 0:
                switchToContacts()
            break
        case 1:
            switchToCalender()

            break
        case 2:
            switchToGallery()

            break
        case 3:
            switchToNotes()

            break
        case 4:
            switchToDocument()
            
            break
        default:
            break
        }
        print("selected")
    }
    func switchToMortagageCalculator(){
    
    }
    func switchToContacts(){
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ResourceContactViewController") as! ResourceContactViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func switchToCalender(){
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CalenderViewController") as! CalenderViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func switchToGallery(){
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "GalleryViewController") as! GalleryViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func switchToNotes(){
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NotesViewController") as! NotesViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func switchToDocument()
    {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DocumentsViewController") as! DocumentsViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
