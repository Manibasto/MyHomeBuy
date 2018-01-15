//
//  UIViewController+Appended.swift
//  MysteryShoppers
//
//  Created by wazid on 19/06/17.
//  Copyright © 2017 MobileCoderz. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func createSettingsAlertController(title: String, message: String) {
        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment:"nil" ), style: .cancel, handler: nil)
        let settingsAction = UIAlertAction(title: NSLocalizedString("Settings", comment:"nil" ), style: .default, handler: { action in
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(URL(string : UIApplicationOpenSettingsURLString)!, options: [:], completionHandler: nil)
            } else {
                // Fallback on earlier versions
                 UIApplication.shared.openURL(URL(string: UIApplicationOpenSettingsURLString)!)
            }
           
        })
        controller.addAction(cancelAction)
        controller.addAction(settingsAction)
        self.present(controller, animated: true, completion: nil)
    }
    
    
}
