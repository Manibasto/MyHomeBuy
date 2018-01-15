//
//  String+Appended.swift
//  MysteryShoppers
//
//  Created by wazid on 27/04/17.
//  Copyright © 2017 MobileCoderz. All rights reserved.
//

import Foundation

extension String
{
    
    
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
    func isContactNumberValid() -> Bool {
        if(self.characters.count >= 8 && self.characters.count <= 16){
            return true
        }
        else{
            return false
        }
    }
    
  
    func removingWhitespaces() -> String {
        return components(separatedBy: .whitespaces).joined()
    }
    func trailingTrim(_ characterSet : CharacterSet) -> String {
        if let range = rangeOfCharacter(from: characterSet, options: [.anchored, .backwards]) {
            return self.substring(to: range.lowerBound).trailingTrim(characterSet)
        }
        return self
    }
    func trimFromLeading() -> String
    {
        return self.trimmingCharacters(in: NSCharacterSet.whitespaces)
    }
    var boolValue: Bool {
        return NSString(string: self).boolValue
    }
    
    func isPasswordSame(_ confirmPassword : String) -> Bool {
        if confirmPassword == self{
            return true
        }else{
            return false
        }
    }
    
    func isLengthValid(_ length : Int) -> Bool {
        if self.characters.count == length{
            return true
        }else{
            return false
        }
    }
    func isLengthValidWithRange(_ minLength : Int , _ maxLength : Int) -> Bool {
        if(self.characters.count >= minLength && self.characters.count <= maxLength){
            return true
        }
        else{
            return false
        }
    }
    public func getInitials(_ separator: String = "") -> String
    {
        let initials = self.components(separatedBy: " ").map({ String($0.characters.first!) }).joined(separator: separator);
        return initials;
    }
    
}
