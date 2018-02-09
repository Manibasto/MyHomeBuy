//
//  DocumentViewerViewController.swift
//  MyHomeBuy
//
//  Created by Vikas on 22/01/18.
//  Copyright © 2018 MobileCoderz. All rights reserved.
//

import UIKit
import MBProgressHUD
import SDWebImage
class DocumentViewerViewController: UIViewController {

    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var documentImageView: UIImageView!
    var model : DocumentModel?
    var isFromGallery = false
    var galleryImageStr = ""
    
    @IBOutlet weak var documentWebView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if isFromGallery {
            documentWebView.isHidden = true
            documentImageView.sd_setImage(with: URL(string:galleryImageStr))
            headerLabel.text = "Gallery"
        }
        else{
            if(model?.file_type == "image"){
                documentWebView.isHidden = true
                let fileName = model?.file_name
                documentImageView.sd_setImage(with: URL(string:fileName!))
                
            }else{
                documentImageView.isHidden = true
                documentWebView.delegate = self
                let fileName = model?.file_name
                let url = URL (string: "\(fileName!)")
                let requestObj = URLRequest(url: url!)
                documentWebView.loadRequest(requestObj)
            }
             headerLabel.text = "Documents"
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    @IBAction func backButtonAction(_ sender: Any) {
        if let navCon = navigationController
        {
            navCon.popViewController(animated: true)
        }
    }
    
    @IBAction func homeButtonAction(_ sender: Any) {
        let navController : UINavigationController  = storyboard?.instantiateViewController(withIdentifier: "SlidingNavigationController") as! UINavigationController
        var controller: UIViewController!
        
        controller = storyboard?.instantiateViewController(withIdentifier: "MyHomeViewController") as? MyHomeViewController
        navController.viewControllers = [controller]
        frostedViewController.contentViewController = navController
    }
    

}

extension DocumentViewerViewController : UIWebViewDelegate{
    func webViewDidStartLoad(_ webView: UIWebView) {
        MBProgressHUD.showAdded(to: self.view, animated: true)
    }
    func webViewDidFinishLoad(_ webView: UIWebView) {
        MBProgressHUD.hide(for: self.view, animated: true)
        webView.scrollView.minimumZoomScale = 1.0
        webView.scrollView.maximumZoomScale = 5.0
       // webView.stringByEvaluatingJavaScript(from: "document.querySelector('meta[name=viewport]').setAttribute('content', 'user-scalable = 1;', false); ")
        
    }
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        
        MBProgressHUD.hide(for: self.view, animated: true)
        view.makeToast("Error loading page")
    }
    
}
