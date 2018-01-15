//
//  UILabel+Appended.swift
//  MysteryShoppers
//
//  Created by wazid on 15/06/17.
//  Copyright © 2017 MobileCoderz. All rights reserved.
//

import Foundation
import UIKit

extension  UILabel{

    func setLocalizedText(_ string : String){
       self.text =  NSLocalizedString(string, comment: "nil");
    }


}
