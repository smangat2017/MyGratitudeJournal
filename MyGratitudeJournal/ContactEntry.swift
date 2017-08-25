//
//  ContactEntry.swift
//  AddressBookContacts
//

import UIKit
import AddressBook
import Contacts

class ContactEntry {
    var _name: String!
    var _phone: String?
    
    init(name: String, phone: String?) {
        self._name = name
        self._phone = phone
    }
    
    init?(cnContact: CNContact) {
        // name
        if !cnContact.isKeyAvailable(CNContactGivenNameKey) && !cnContact.isKeyAvailable(CNContactFamilyNameKey) { return nil }
        self._name = (cnContact.givenName + " " + cnContact.familyName).trimmingCharacters(in: CharacterSet.whitespaces)
              // phone
        if cnContact.isKeyAvailable(CNContactPhoneNumbersKey) {
            if cnContact.phoneNumbers.count > 0 {
                let phone = cnContact.phoneNumbers.first?.value
                self._phone = phone?.stringValue
            }
        }
    }
}
