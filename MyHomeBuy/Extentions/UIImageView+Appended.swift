//
//  UIImageView+Appended.swift
//  MysteryShoppers
//
//  Created by wazid on 05/06/17.
//  Copyright © 2017 MobileCoderz. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView
{
    func getFileName() -> String? {
        // First set accessibilityIdentifier of image before calling.
        let imgName = self.image?.accessibilityIdentifier
        return imgName
    }
}
