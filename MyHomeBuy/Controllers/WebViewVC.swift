//
//  WebViewVC.swift
//  MyHomeBuy
//
//  Created by Vikas on 27/10/17.
//  Copyright © 2017 MobileCoderz. All rights reserved.
//

import UIKit
import MBProgressHUD
class WebViewVC: UIViewController {
    @IBOutlet weak var customWebView: UIWebView!
    @IBOutlet weak var navigationBarView: UIView!
    @IBOutlet weak var titleLbl: UILabel!
    var currentIndex = 0
    var currentTitle = ""
    
  
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
       
        //navigationBarView.setBottomShadow()

        if(currentIndex == 0){
            currentTitle = "Privacy Policy"

        }else{
            currentTitle = "Terms of Use"

        }
        
        titleLbl.text = currentTitle
        requestWebView()
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        navigationBarView.setBottomShadow()
    }
    func requestWebView(){
        customWebView.delegate = self
        var link = ""

        if(currentIndex == 0){
            link = PRIVACY_POLICY

        }else{
            link = TERMS_CONDITION

        }
        let url = URL (string: link)
        let requestObj = URLRequest(url: url!)
        customWebView.loadRequest(requestObj)
     
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backBtnPressed(_ sender: UIButton) {
        frostedViewController.presentMenuViewController()

    }
    
    @IBAction func homeButtonTapped(_ sender: Any) {
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

extension WebViewVC : UIWebViewDelegate{
    func webViewDidStartLoad(_ webView: UIWebView) {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
    }
    func webViewDidFinishLoad(_ webView: UIWebView) {
        MBProgressHUD.hide(for: self.view, animated: true)
        
        
    }
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        
        MBProgressHUD.hide(for: self.view, animated: true)
        view.makeToast("Error loading page")
    }
    
}
