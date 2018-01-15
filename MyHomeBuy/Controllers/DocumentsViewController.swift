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

class DocumentsViewController: UIViewController {
    
   
    @IBOutlet weak var taskDocumentLbl: UILabel!
    @IBOutlet weak var taskDocumentImageView: UIImageView!
    @IBOutlet weak var taskHeadingView: UIView!
    @IBOutlet weak var navigationBarView: UIView!
    @IBOutlet weak var headingHeightConstraint: NSLayoutConstraint!

    @IBOutlet weak var imageLineLabel: UILabel!
    @IBOutlet weak var pdfLineLabel: UILabel!
    @IBOutlet weak var imageBtn: UIButton!
    
    @IBOutlet weak var pdfBtn: UIButton!
    @IBOutlet weak var containerView: UIView!
    var currentTaskID = "0"
    var dataDict = NSDictionary()
    var fromTask = false

    override func viewDidLoad() {
        super.viewDidLoad()
        pdfLineLabel.isHidden=true
        imageLineLabel.isHidden=false;
        SharedAppDelegate.currentTaskID = currentTaskID
        // Do any additional setup after loading the view.
        if(fromTask){
            setupHeaderData()
            taskDocumentLbl.isHidden = false

        }else{
            headingHeightConstraint.constant = 0
            taskDocumentLbl.isHidden = true
        }
    updateView(index: 0)
        requestGetDocumentAPI()
    }
    func setupHeaderData(){
        let image = UIImage.init(named: (dataDict.object(forKey: "image_white") as! String?)!)
        taskDocumentImageView.image = image
        let title = dataDict.object(forKey: "headerText") as! String?
        taskDocumentLbl.text = title
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
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
    
    @IBAction func imageButtonAction(_ sender: Any)
    {
       // [imageBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
           imageBtn.setTitleColor(UIColor.white, for: .normal)
           pdfBtn.setTitleColor(UIColor.lightWhite, for: .normal)
           imageLineLabel.isHidden=false
           pdfLineLabel.isHidden=true
        updateView(index: 0)
       // removeFromContainer()
//        let pdfVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ImageViewController") as! ImageViewController
//        pdfVC.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//
//           pdfVC.view.frame(forAlignmentRect: CGRect(x: 0, y: 0, width:containerView.frame.size.width, height:containerView.frame.size.height))
//               containerView.addSubview(pdfVC.view)
//               addChildViewController(pdfVC)
      }
   
    @IBAction func pdfButtonAction(_ sender: Any)
    {
        imageBtn.setTitleColor(UIColor.lightWhite, for: .normal)
        pdfBtn.setTitleColor(UIColor.white, for: .normal)
        imageLineLabel.isHidden=true
        pdfLineLabel.isHidden=false
        updateView(index: 1)
        // removeFromContainer()
//        let pdfVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PdfViewController") as! PdfViewController
//            pdfVC.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        pdfVC.view.frame(forAlignmentRect: CGRect(x: 0, y: 0, width: containerView.frame.size.width, height: containerView.frame.size.height))
//        containerView.addSubview(pdfVC.view)
//        addChildViewController(pdfVC)
    }
    func removeFromContainer()
    {
        let allView = containerView.subviews
        for singleView in allView
        {
            singleView.removeFromSuperview()
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    private lazy var pdfViewController: PdfViewController = {
        // Load Storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        // Instantiate View Controller
        var viewController = storyboard.instantiateViewController(withIdentifier: "PdfViewController") as! PdfViewController
        
        // Add View Controller as Child View Controller
        self.add(asChildViewController: viewController)
        
        return viewController
    }()
    
    private lazy var imageViewController: ImageViewController = {
        // Load Storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        // Instantiate View Controller
        var viewController = storyboard.instantiateViewController(withIdentifier: "ImageViewController") as! ImageViewController
        
        // Add View Controller as Child View Controller
        self.add(asChildViewController: viewController)
        
        return viewController
    }()
    
    private func updateView(index : Int) {
        if index == 1 {
            remove(asChildViewController: imageViewController)
            add(asChildViewController: pdfViewController)
            //pdfViewController.currentTaskID = currentTaskID;
        } else {
            remove(asChildViewController: pdfViewController)
            add(asChildViewController: imageViewController)
           // imageViewController.currentTaskID = currentTaskID;

        }
    }

    private func add(asChildViewController viewController: UIViewController) {
        // Add Child View Controller
        addChildViewController(viewController)
        
        // Add Child View as Subview
        containerView.addSubview(viewController.view)
        
        // Configure Child View
        viewController.view.frame = containerView.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // Notify Child View Controller
        viewController.didMove(toParentViewController: self)
       
    }
    
    private func remove(asChildViewController viewController: UIViewController) {
        // Notify Child View Controller
        viewController.willMove(toParentViewController: nil)
        
        // Remove Child View From Superview
        viewController.view.removeFromSuperview()
        
        // Notify Child View Controller
        viewController.removeFromParentViewController()
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
