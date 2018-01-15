//
//  UIButton+Appended.swift
//  MysteryShoppers
//
//  Created by wazid on 12/06/17.
//  Copyright © 2017 MobileCoderz. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {
    func centerTextAndImage(spacing: CGFloat) {
        let insetAmount = spacing / 2
        let writingDirection = UIApplication.shared.userInterfaceLayoutDirection
        let factor: CGFloat = writingDirection == .leftToRight ? 1 : -1
        
        self.imageEdgeInsets = UIEdgeInsets(top: 0, left: -insetAmount*factor, bottom: 0, right: insetAmount*factor)
        self.titleEdgeInsets = UIEdgeInsets(top: 0, left: insetAmount*factor, bottom: 0, right: -insetAmount*factor)
        self.contentEdgeInsets = UIEdgeInsets(top: 0, left: insetAmount, bottom: 0, right: insetAmount)
    }
    
    func getSelectedButtonTag() -> UIButton{
        
        return UIButton()
    }
    
    
//    func setTitleForNormalState(_ title : String){
//        self.setTitle(title, for: .normal)
//    }
    
    func setLocalizedTitleForNormalState(_ title : String){
        self.setTitle(NSLocalizedString(title, comment: "nil"), for: .normal)
    }
    
    
}
