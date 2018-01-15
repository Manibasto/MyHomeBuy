//
//  TermsOfUseViewController.swift
//  MyHomeBuy
//
//  Created by Vikas on 05/10/17.
//  Copyright © 2017 MobileCoderz. All rights reserved.
//

import UIKit
import MBProgressHUD
class TermsOfUseViewController: UIViewController {

    @IBOutlet weak var customWebView: UIWebView!
    @IBOutlet weak var navigationBarView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationBarView.setBottomShadow()
        requestWebView()
    }
    
    func requestWebView(){
        customWebView.delegate = self
        let url = URL (string: TERMS_CONDITION)
        let requestObj = URLRequest(url: url!)
        customWebView.loadRequest(requestObj)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        frostedViewController.panGestureEnabled = true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func menuBtnPressed(_ sender: Any) {
        frostedViewController.presentMenuViewController()

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

extension TermsOfUseViewController : UIWebViewDelegate{
    func webViewDidStartLoad(_ webView: UIWebView) {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
    }
    func webViewDidFinishLoad(_ webView: UIWebView) {
        MBProgressHUD.hide(for: self.view, animated: true)
        
        
    }
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        
        MBProgressHUD.hide(for: self.view, animated: true)
        view.makeToast("Error loading data")
    }
    
}
