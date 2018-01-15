//
//  UIColor+Appended.swift
//  MysteryShoppers
//
//  Created by wazid on 08/06/17.
//  Copyright © 2017 MobileCoderz. All rights reserved.
//

import Foundation
import UIKit
//abhi89kanpur@gmail.com
extension UIColor{
//    open class var lightBlue: UIColor {
//        return UIColor.init(colorLiteralRed: 0.0/255.0, green: 172.0/255.0, blue: 186.0/255.0, alpha: 1)
//    }
    static let lighterGray = UIColor.init(colorLiteralRed: 248.0/255.0, green: 248.0/255.0, blue: 248.0/255.0, alpha: 1)
    static let lightBlue = UIColor.init(colorLiteralRed: 0.0/255.0, green: 175.0/255.0, blue: 191.0/255.0, alpha: 1)
    static let lightWhite = UIColor.init(colorLiteralRed: 231.0/255.0, green: 227.0/255.0, blue: 224.0/255.0, alpha: 1)
     static let color1 = UIColor.init(colorLiteralRed: 130.0/255.0, green: 130.0/255.0, blue: 130.0/255.0, alpha: 1)
    static let color2 = UIColor.init(colorLiteralRed: 66.0/255.0, green: 66.0/255.0, blue: 66.0/255.0, alpha: 1)
    
    static let mileStoneColor1 = UIColor.init(colorLiteralRed: 216.0/255.0, green: 83.0/255.0, blue: 66.0/255.0, alpha: 1.0)
    static let mileStoneColor2 = UIColor.init(colorLiteralRed: 238.0/255.0, green: 159.0/255.0, blue: 30.0/255.0, alpha: 1.0)
    static let mileStoneColor3 = UIColor.init(colorLiteralRed: 142.0/255.0, green: 195.0/255.0, blue: 65.0/255.0, alpha: 1.0)
    static let mileStoneColor4 = UIColor.init(colorLiteralRed: 65.0/255.0, green: 196.0/255.0, blue: 165.0/255.0, alpha: 1.0)
    static let mileStoneColor5 = UIColor.init(colorLiteralRed: 0.0/255.0, green: 175.0/255.0, blue: 192.0/255.0, alpha: 1.0)
    static let mileStoneColor6 = UIColor.init(colorLiteralRed: 136.0/255.0, green: 73.0/255.0, blue: 190.0/255.0, alpha: 1.0)
    static let mileStoneColor7 = UIColor.init(colorLiteralRed: 185.0/255.0, green: 83.0/255.0, blue: 157.0/255.0, alpha: 1.0)
    
    
    static let mileStoneColor11 = UIColor.init(colorLiteralRed: 231/255.0, green: 108/255.0, blue: 92/255.0, alpha: 1.0)
    static let mileStoneColor12 = UIColor.init(colorLiteralRed: 248.0/255.0, green: 172.0/255.0, blue: 49.0/255.0, alpha: 1.0)
    static let mileStoneColor13 = UIColor.init(colorLiteralRed: 155.0/255.0, green: 206.0/255.0, blue: 82.0/255.0, alpha: 1.0)
    static let mileStoneColor14 = UIColor.init(colorLiteralRed: 79.0/255.0, green: 211.0/255.0, blue: 182.0/255.0, alpha: 1.0)
    static let mileStoneColor15 = UIColor.init(colorLiteralRed: 9.0/255.0, green: 190.0/255.0, blue: 207.0/255.0, alpha: 1.0)
    static let mileStoneColor16 = UIColor.init(colorLiteralRed: 147.0/255.0, green: 85.0/255.0, blue: 198.0/255.0, alpha: 1.0)
    static let mileStoneColor17 = UIColor.init(colorLiteralRed: 194.0/255.0, green: 96.0/255.0, blue: 169.0/255.0, alpha: 1.0)
    
     static let graphColor = UIColor.init(colorLiteralRed: 245.0/255.0, green: 245.0/255.0, blue: 245.0/255.0, alpha: 1.0)
    static let customBlackColor = UIColor.init(colorLiteralRed: 46.0/255.0, green: 46.0/255.0, blue: 46.0/255.0, alpha: 1.0)
    //usage
//     let color = UIColor.red
//    
//    let hex = color.toHexString
//    // hex = "FF0000"
    var toHexString: String {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        self.getRed(&r, green: &g, blue: &b, alpha: &a)
        
        return String(
            format: "%02X%02X%02X",
            Int(r * 0xff),
            Int(g * 0xff),
            Int(b * 0xff)
        )
    }
    
    //usage
    //let color = UIColor(hex: "ff0000")

    convenience init(hex: String) {
        let scanner = Scanner(string: hex)
        scanner.scanLocation = 0
        
        var rgbValue: UInt64 = 0
        
        scanner.scanHexInt64(&rgbValue)
        
        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
        
        self.init(
            red: CGFloat(r) / 0xff,
            green: CGFloat(g) / 0xff,
            blue: CGFloat(b) / 0xff, alpha: 1
        )
    }

}
