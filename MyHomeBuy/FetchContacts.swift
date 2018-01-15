//
//  FetchContacts.swift
//  MyHomeBuy
//
//  Created by Vikas on 18/11/17.
//  Copyright © 2017 MobileCoderz. All rights reserved.
//

import Foundation
import Contacts
protocol GetPhoneNumbers {
    func getAllContact(contactArray : [String])
}
class FetchContacts{
    var contactStore = CNContactStore()
    var contacts : [CNContact]?
    var delegate : GetPhoneNumbers?
    
    static let sharedInstance   =   FetchContacts()
    
    fileprivate init(){
       
    }
   
    func getContact() {
        requestAccessToContacts { (success) in
            if success {
                self.retrieveContacts({ (success, contacts) in
                    if success && (contacts?.count)! > 0 {
                        self.contacts = contacts!
                        //self.tableView.reloadData()
                        let phoneNumbers = self.getPhoneNumbers()
                        self.delegate?.getAllContact(contactArray: phoneNumbers)
                    } else {
                        print("Unable to get contacts...")
                       
                    }
                })
            }
        }
    }
    
    
    func requestAccessToContacts(_ completion: @escaping (_ success: Bool) -> Void) {
        let authorizationStatus = CNContactStore.authorizationStatus(for: CNEntityType.contacts)
        
        switch authorizationStatus {
        case .authorized: completion(true) // authorized previously
        case .denied, .notDetermined: // needs to ask for authorization
            self.contactStore.requestAccess(for: CNEntityType.contacts, completionHandler: { (accessGranted, error) -> Void in
                completion(accessGranted)
                if(!accessGranted){
                print("permission denied")
                }
            })
        default: // not authorized.
            completion(false)
        }
    }
    
    func retrieveContacts(_ completion: (_ success: Bool, _ contacts: [CNContact]?) -> Void) {
        var contacts = [CNContact]()
        do {
            let contactsFetchRequest = CNContactFetchRequest(keysToFetch: [CNContactPhoneNumbersKey as CNKeyDescriptor])
            
            //            let contactsFetchRequest = CNContactFetchRequest(keysToFetch: [CNContactGivenNameKey as CNKeyDescriptor, CNContactFamilyNameKey as CNKeyDescriptor, CNContactImageDataKey as CNKeyDescriptor, CNContactImageDataAvailableKey as CNKeyDescriptor, CNContactPhoneNumbersKey as CNKeyDescriptor, CNContactEmailAddressesKey as CNKeyDescriptor])
            try contactStore.enumerateContacts(with: contactsFetchRequest, usingBlock: { (cnContact, error) in
                contacts.append(cnContact)
                //                print(cnContact)
                //                if let contact = ContactEntry(cnContact: cnContact) { contacts.append(contact)
                //
                //                }
            })
            completion(true, contacts)
        } catch {
            completion(false, nil)
        }
    }
    func getPhoneNumbers()->[String]{
        var phoneNo = [String]()
        for contact in contacts! {
            //print(contact.phoneNumbers)
            if contact.isKeyAvailable(CNContactPhoneNumbersKey) {
                if contact.phoneNumbers.count > 0 {
                    for contactNo in contact.phoneNumbers {
                        let phone = contactNo.value
                        let phoneStr = phone.stringValue
                        let y = phoneStr.replacingOccurrences(of: "[() -]", with: "", options: .regularExpression, range: nil)
                        print(y)
                        phoneNo.append(y)
                      
                    }
                }
            }
        }
        return phoneNo
    }
}
