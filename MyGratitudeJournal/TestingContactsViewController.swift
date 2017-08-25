//
//  TestingContactsViewController.swift
//  MyGratitudeJournal
//
//  Created by Simar Mangat on 8/24/17.
//  Copyright © 2017 Simar Mangat. All rights reserved.
//

import UIKit
import Contacts


class TestingContactsViewController: UIViewController {
    
    @IBOutlet weak var textBox: UITextField!
    
    // data
    var contactStore = CNContactStore()
    var contacts = [ContactEntry]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestAccessToContacts { (success) in
            if success {
                self.retrieveContacts({ (success, contacts) in
                    if success && (contacts?.count)! > 0 {
                        self.contacts = contacts!
                    } else {
                        print("Unable to get contacts")
                    }
                })
            }
        }
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func editingChange(_ sender: Any) {
        let atIndex = self.textBox.text.index(of: "@")
        if atIndex != self.textBox.endIndex {
            var attributedString = NSMutableAttributedString(string: self.textBox.text)
            var remainingString = self.textBox.suffix(from: atIndex)
            spaceIndex = remaininString.index(of: " ")
            attributedString.addAttribute(NSForegroundColorAttributeName, value: NSColor.redColor() , range: range)
            
        }
        
    }
    
    func requestAccessToContacts(_ completion: @escaping (_ success: Bool) -> Void) {
        let authorizationStatus = CNContactStore.authorizationStatus(for: CNEntityType.contacts)
        
        switch authorizationStatus {
        case .authorized: completion(true) // authorized previously
        case .denied, .notDetermined: // needs to ask for authorization
            self.contactStore.requestAccess(for: CNEntityType.contacts, completionHandler: { (accessGranted, error) -> Void in
                completion(accessGranted)
            })
        default: // not authorized.
            completion(false)
        }
    }
    
    func retrieveContacts(_ completion: (_ success: Bool, _ contacts: [ContactEntry]?) -> Void) {
        var contacts = [ContactEntry]()
        do {
            let contactsFetchRequest = CNContactFetchRequest(keysToFetch: [CNContactGivenNameKey as CNKeyDescriptor, CNContactFamilyNameKey as CNKeyDescriptor, CNContactImageDataKey as CNKeyDescriptor, CNContactImageDataAvailableKey as CNKeyDescriptor, CNContactPhoneNumbersKey as CNKeyDescriptor, CNContactEmailAddressesKey as CNKeyDescriptor])
            try contactStore.enumerateContacts(with: contactsFetchRequest, usingBlock: { (cnContact, error) in
                if let contact = ContactEntry(cnContact: cnContact) { contacts.append(contact) }
            })
            completion(true, contacts)
        } catch {
            completion(false, nil)
        }
    }

}
