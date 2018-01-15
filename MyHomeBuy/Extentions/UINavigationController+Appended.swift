//
//  UINavigationController+Appended.swift
//  MysteryShoppers
//
//  Created by wazid on 13/06/17.
//  Copyright © 2017 MobileCoderz. All rights reserved.
//

import Foundation
import UIKit

extension UINavigationController {
    func replaceTopViewController(with viewController: UIViewController, animated: Bool) {
        var vcs = viewControllers
        vcs[vcs.count - 1] = viewController
        setViewControllers(vcs, animated: animated)
    }
    
        func popTo(controllerToPop:UIViewController)  {
            let controllers = self.viewControllers
            for controller in controllers {
                if(controller == controllerToPop) {
                    self.popTo(controllerToPop: controllerToPop)
                }
            }
        }
    
}
