//
//  SearchViewController.swift
//  MyHomeBuy
//
//  Created by Vikas on 07/11/17.
//  Copyright © 2017 MobileCoderz. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet weak var searchWebView: UIWebView!
    @IBOutlet weak var navigationBarView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let url = URL (string: "https://www.google.co.in")
        let requestObj = URLRequest(url: url!)
        searchWebView.loadRequest(requestObj)
    }
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        frostedViewController.panGestureEnabled = true
//
//    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        navigationBarView.setBottomShadow()
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
