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
    
    @IBOutlet weak var myTextField: SearchTextField!
    
    // data
    var contactStore = CNContactStore()
    var contacts = [ContactEntry]()
    var names = [String]()
    
    
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
        names = contacts.map{$0.name.lowercased()}
        self.myTextField.inlineMode = true
        self.myTextField.startFilteringAfter = "@"
        self.myTextField.startSuggestingInmediately = true
        self.myTextField.filterStrings(names)
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    
    }
    @IBAction func editingChange(_ sender: Any) {
        let pattern = "@((\\w+)(?:\\s\\w+)?)"
        let inString = self.myTextField.text!
        let regex = try? NSRegularExpression(pattern: pattern, options: [])
        let range = NSMakeRange(0, inString.characters.count)
        let matches = (regex?.matches(in: inString, options: [], range: range))!
        let attrString = NSMutableAttributedString(string: inString, attributes:nil)
        //Iterate over regex matches
        for match in matches.reversed() {
            for i in 1...2{
                let matchRange = match.rangeAt(i)
                //Properly print match range
                let contact = (inString as NSString).substring(with: matchRange).lowercased()
                if names.contains(contact){
                    attrString.addAttribute(NSForegroundColorAttributeName, value: UIColor.orange , range: matchRange)
                }
            }

        }
        self.myTextField.attributedText = attrString
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
