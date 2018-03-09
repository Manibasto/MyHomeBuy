//
//  UIView+Appended.swift
//  MysteryShoppers
//
//  Created by Vikas on 04/10/17.
//  Copyright © 2017 MobileCoderz. All rights reserved.
//

import Foundation
import UIKit
extension UIView{
    func setBottomShadow() {
        layer.cornerRadius = 2
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 1)
        layer.shadowOpacity = 0.45
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shadowRadius = 1.0
    }
    func setShadow(){
        let shadowPath = UIBezierPath()
        shadowPath.move(to: CGPoint(x: bounds.origin.x, y: frame.size.height))
        //shadowPath.addLine(to: CGPoint(x: bounds.width / 2, y: bounds.height + 7.0))
        shadowPath.addLine(to: CGPoint(x: bounds.width, y: bounds.height))
        shadowPath.close()
        
        layer.shadowColor = UIColor.darkGray.cgColor
        layer.shadowOpacity = 1
        layer.masksToBounds = false
        layer.shadowPath = shadowPath.cgPath
        layer.shadowRadius = 5
    }
    func setRadius(_ corner : CGFloat){
        layer.cornerRadius = corner
        layer.masksToBounds = true
    }
    
    func setRadius(_ corner : CGFloat , _ color : UIColor){
        layer.cornerRadius = corner
        layer.masksToBounds = true
        layer.borderWidth = 3
        layer.borderColor = color.cgColor
    }
    
    func setRadius(_ corner : CGFloat , _ color : UIColor , _ borderWidth : CGFloat)
    {
        layer.cornerRadius = corner
        layer.masksToBounds = true
        layer.borderWidth = borderWidth
        layer.borderColor = color.cgColor
    }
    
    static func getViewWithTag(_ viewArray : [UIView] , _ tag : Int) -> UIView{
        var currentView : UIView?
        for view in viewArray {
            if(view.tag == tag){
            currentView = view
            break;
            }
        }
        return currentView!
    }
}
