//
//  UIImage+Appended.swift
//  MysteryShoppers
//
//  Created by wazid on 25/07/17.
//  Copyright © 2017 MobileCoderz. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    func resize(_ resizeToImageSize : CGSize , _ compressionQuality : CGFloat) -> UIImage?{
        let horizontalRatio = resizeToImageSize.width / size.width
        let verticalRatio = resizeToImageSize.height / size.height
        
        let ratio = max(horizontalRatio, verticalRatio)
        let newSize = CGSize(width: size.width * ratio, height: size.height * ratio)
        UIGraphicsBeginImageContextWithOptions(newSize, true, 0)
        draw(in: CGRect(origin: CGPoint(x: 0, y: 0), size: newSize))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        guard let finalResizedImage = resizedImage else{return resizedImage}
        guard let imageData = UIImageJPEGRepresentation(finalResizedImage, compressionQuality) else{return resizedImage}
        guard let finalCompressedImage = UIImage(data: imageData) else{return resizedImage}
        return finalCompressedImage
    }
    
//    func resizeImageWith(newSize: CGSize) -> UIImage {
//
//        let horizontalRatio = newSize.width / size.width
//        let verticalRatio = newSize.height / size.height
//
//        let ratio = max(horizontalRatio, verticalRatio)
//        let newSize = CGSize(width: size.width * ratio, height: size.height * ratio)
//        UIGraphicsBeginImageContextWithOptions(newSize, true, 0)
//        draw(in: CGRect(origin: CGPoint(x: 0, y: 0), size: newSize))
//        let newImage = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        return newImage!
//    }
//
//
//
//    func resized(withPercentage percentage: CGFloat) -> UIImage? {
//        let canvasSize = CGSize(width: size.width * percentage, height: size.height * percentage)
//        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
//        defer { UIGraphicsEndImageContext() }
//        draw(in: CGRect(origin: .zero, size: canvasSize))
//        return UIGraphicsGetImageFromCurrentImageContext()
//    }
//    func resized(toWidth width: CGFloat) -> UIImage? {
//        let canvasSize = CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))
//        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
//        defer { UIGraphicsEndImageContext() }
//        draw(in: CGRect(origin: .zero, size: canvasSize))
//        return UIGraphicsGetImageFromCurrentImageContext()
//    }
//    /// Returns a image that fills in newSize
//    func resizedImage(newSize: CGSize) -> UIImage {
//        // Guard newSize is different
//        guard self.size != newSize else { return self }
//
//        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0);
//
//        draw(in: CGRect(x: 0 , y : 0 , width : newSize.width , height : newSize.height))
//        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
//        UIGraphicsEndImageContext()
//        return newImage
//    }
//
//    /// Returns a resized image that fits in rectSize, keeping it's aspect ratio
//    /// Note that the new image size is not rectSize, but within it.
//    func resizedImageWithinRect(rectSize: CGSize) -> UIImage {
//        let widthFactor = size.width / rectSize.width
//        let heightFactor = size.height / rectSize.height
//
//        var resizeFactor = widthFactor
//        if size.height > size.width {
//            resizeFactor = heightFactor
//        }
//
//
//        let newSize = CGSize(width : size.width/resizeFactor , height : size.height/resizeFactor)
//        let resized = resizedImage(newSize: newSize)
//        return resized
//    }
//
//    func isEqualToImage(image: UIImage) -> Bool {
//        let data1: NSData = UIImagePNGRepresentation(self)! as NSData
//        let data2: NSData = UIImagePNGRepresentation(image)! as NSData
//        return data1.isEqual(data2)
//    }
//
//
//    var highestQualityJPEGNSData: NSData { return UIImageJPEGRepresentation(self, 1.0)! as NSData }
//    var highQualityJPEGNSData: NSData    { return UIImageJPEGRepresentation(self, 0.75)! as NSData}
//    var mediumQualityJPEGNSData: NSData  { return UIImageJPEGRepresentation(self, 0.5)! as NSData }
//    var lowQualityJPEGNSData: NSData     { return UIImageJPEGRepresentation(self, 0.25)! as NSData}
//    var lowestQualityJPEGNSData: NSData  { return UIImageJPEGRepresentation(self, 0.0)! as NSData }
    
}
