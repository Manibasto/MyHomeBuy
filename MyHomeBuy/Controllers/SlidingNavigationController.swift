//
//  SlidingNavigationController.swift
//  MyHomeBuy
//
//  Created by Vikas on 05/10/17.
//  Copyright © 2017 MobileCoderz. All rights reserved.
//

import UIKit

class SlidingNavigationController: UINavigationController,UIGestureRecognizerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let myPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognized))
        
        myPanGestureRecognizer.minimumNumberOfTouches = 1
        myPanGestureRecognizer.maximumNumberOfTouches = 1
        myPanGestureRecognizer.delegate = self
        view.addGestureRecognizer(myPanGestureRecognizer)
        //addEdgeGesture()
    }
    func addEdgeGesture(){
        let edgeGestureRecognizer = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(userSwipedFromEdge(_:)))
        edgeGestureRecognizer.edges = UIRectEdge.left
        edgeGestureRecognizer.delegate = self
        view.addGestureRecognizer(edgeGestureRecognizer)
        
    }
    func userSwipedFromEdge(_ sender: UIScreenEdgePanGestureRecognizer) {
        if sender.edges == UIRectEdge.left {
            print("It works!")
            frostedViewController.panGestureEnabled = true
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func panGestureRecognized(_ sender : UIPanGestureRecognizer)
    {
        
        frostedViewController.panGestureRecognized(sender)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        let point = touch.location(in: gestureRecognizer.view)
        if point.x < 50.0{
            return true
        }
        return false
    }/*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
