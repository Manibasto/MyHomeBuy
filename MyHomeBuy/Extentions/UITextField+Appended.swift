//
//  UITextField+Appended.swift
//  MysteryShoppers
//
//  Created by wazid on 16/05/17.
//  Copyright © 2017 MobileCoderz. All rights reserved.
//

import Foundation
import UIKit
extension UITextField{
    
    func applyPadding(padding: Int){
        
        let paddingView = UIView.init(frame: CGRect(x: 0,y:0,width: padding,height: Int(self.frame.size.height)))
        self.leftView = paddingView
        self.leftViewMode = .always
        //paddingView.backgroundColor = UIColor.green
    }
    
    func setRightView(imageName: String){
        
        let imageView = UIImageView.init(frame: CGRect(x: 0,y:0,width: Int(self.frame.size.height),height: Int(self.frame.size.height)))
        let image = UIImage.init(named: imageName)
        imageView.image = image
        self.rightView = imageView
        self.rightViewMode = .always
        
        
    }
    func setLeftView(imageName: String){
        
        let imageView = UIImageView.init(frame: CGRect(x: 0,y:0,width: Int(self.frame.size.height),height: Int(self.frame.size.height)))
        let image = UIImage.init(named: imageName)
        imageView.image = image
        self.leftView = imageView
        self.leftViewMode = .always
        
        
    }
    func setLeftLabel(_ str: String , _ color : UIColor){
        
        let lbl = UILabel.init(frame: CGRect(x: 0,y:0,width: Int(self.frame.size.height * 0.7),height: Int(self.frame.size.height)))
        self.leftView = lbl
        lbl.text = str
        lbl.textColor = color
        lbl.textAlignment = .center
        self.leftViewMode = .always
        
        
    }
    func isEmpty() -> Bool{
        if(self.text == ""){
            return true
        }
        return false
    }
    
    func clearText(){
        self.text = ""
        
    }
    
    enum Direction
    {
        case Left
        case Right
    }
    
    func AddImage(direction:Direction,imageName:String,Frame:CGRect,backgroundColor:UIColor)
    {
        let View = UIView(frame: Frame)
        View.backgroundColor = backgroundColor
        
        let imageView = UIImageView(frame: Frame)
        imageView.image = UIImage(named: imageName)
        
        View.addSubview(imageView)
        
        if Direction.Left == direction
        {
            self.leftViewMode = .always
            self.leftView = View
        }
        else
        {
            self.rightViewMode = .always
            self.rightView = View
        }
    }
    
}


//func qw(){
//    //textView.delegate = self
//    let str = "By creating an account you agree to our\nUser Agreement and Privacy Policy"
//    //        let str = "By continuing, you accept the Terms of use and Privacy policy"
//    let attributedString = NSMutableAttributedString(string: str)
//    var foundRange = attributedString.mutableString.range(of: "User Agreement") //mention the parts of the attributed text you want to tap and get an custom action
//    attributedString.addAttribute(NSLinkAttributeName, value: termsAndConditionsURL, range: foundRange)
//    foundRange = attributedString.mutableString.range(of: "Privacy Policy")
//    attributedString.addAttribute(NSLinkAttributeName, value: privacyURL, range: foundRange)
//    termsLbl.attributedText = attributedString
//    //        textView.isEditable = false
//    //        textView.isSelectable = true
//    //        textView.textAlignment = .center
//    
//}
