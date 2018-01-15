//
//  DocumentsViewController.swift
//  MyHomeBuy
//
//  Created by Santosh Rawani on 11/01/18.
//  Copyright © 2018 MobileCoderz. All rights reserved.
//

import UIKit

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
    override func viewDidLoad() {
        super.viewDidLoad()
        pdfLineLabel.isHidden=true
        imageLineLabel.isHidden=false;

        // Do any additional setup after loading the view.
    updateView(index: 0)
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
        } else {
            remove(asChildViewController: pdfViewController)
            add(asChildViewController: imageViewController)
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
