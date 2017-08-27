//
//  ViewController.swift
//  MyGratitudeJournal
//
//  Created by Simar Mangat on 8/21/17.
//  Copyright © 2017 Simar Mangat. All rights reserved.
//

import UIKit
import Contacts
import FirebaseDatabase
import FirebaseAuthUI
import FirebasePhoneAuthUI
import Firebase


class NewEntryViewController: UIViewController, UITextFieldDelegate, AKPickerViewDataSource, AKPickerViewDelegate, FUIAuthDelegate {
    
    fileprivate(set) var auth:Auth?
    fileprivate(set) var authUI: FUIAuth? 
    fileprivate(set) var authStateListenerHandle: AuthStateDidChangeListenerHandle?
    
    
    var contactStore = CNContactStore()
    var contacts = [ContactEntry]()
    var names = [String]()
    var mentions = [String: Set<String>]()
    
    let emotions = ["😢", "😤", "😱", "🤗", "😇", "🤔", "🙃", "😎"]
    let emoLabels = ["sad", "mad", "scared", "joyful", "peaceful", "musing",  "silly", "powerful"]

    
    @IBOutlet weak var pickerView: AKPickerView!
    
    @IBOutlet weak var xcitedThirdEntry: SearchTextField!
    @IBOutlet weak var xcitedSecondEntry: SearchTextField!
    @IBOutlet weak var xcitedFirstEntry: SearchTextField!
    @IBOutlet weak var gtudeThirdEntry: SearchTextField!
    @IBOutlet weak var gtudeSecondEntry: SearchTextField!
    @IBOutlet weak var gtudeFirstEntry: SearchTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpFireBaseAuthUI()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(NewEntryViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        initializeContactsOnLoad()
        setUpPickerWheel()
        setUpSearchFields()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func createNewEntry(_ sender: Any) {
        if Auth.auth().currentUser != nil {
            print(Auth.auth().currentUser!)
            let currentDate = getDate()
            let entry = Entry(gfirst: gtudeFirstEntry.text!, gsecond: gtudeSecondEntry.text!, gthird: gtudeThirdEntry.text!, xfirst: xcitedFirstEntry.text!, xsecond: xcitedSecondEntry.text!, xthird: xcitedThirdEntry.text!, emotion: self.self.emotions[pickerView.selectedItem], date: currentDate)
            let ref = Database.database().reference()
            let key = ref.child("journalEntries").childByAutoId().key
            let gratitudeEntry = ["gtudeFirstEntry" : entry.gtudeFirstEntry,
                                  "gtudeSecondEntry" : entry.gtudeSecondEntry,
                                  "gtudeThirdEntry" : entry.gtudeThirdEntry,
                                  "xcitedFirstEntry" : entry.xcitedFirstEntry,
                                  "xcitedSecondEntry" : entry.xcitedSecondEntry,
                                  "xcitedThirdEntry" : entry.xcitedThirdEntry,
                                  "emotion" : entry.entryEmotion,
                                  "date" : entry.entryDate]
            let gratitudeUpdate = ["/journalEntries/\(key)": gratitudeEntry]
            ref.updateChildValues(gratitudeUpdate, withCompletionBlock: { (error, ref) -> Void in
                self.navigationController?.popViewController(animated: true)
            })
            clearTextLabels()
            self.tabBarController?.selectedIndex = 1            // ...
        } else {
            print("No user currently signed in :(")
        }
    }
    
    
    @IBAction func gtudeFirstEdited(_ sender: Any) {
        let inString = self.gtudeFirstEntry.text!
        let (newString, references) = generateAttStringAtMentionsHighlighted(inString: inString)
        self.gtudeFirstEntry.attributedText = newString
        self.mentions["gtudeFirstEntry"] = references
    }
    
    @IBAction func gtudeSecondEdited(_ sender: Any) {
        let inString = self.gtudeSecondEntry.text!
        let (newString, references) = generateAttStringAtMentionsHighlighted(inString: inString)
        self.gtudeSecondEntry.attributedText = newString
        self.mentions["gtudeSecondEntry"] = references
        print(mentions)
    }
    
    @IBAction func gtudeThirdEdited(_ sender: Any) {
        
    }
    
    @IBAction func xcitedFirstEdited(_ sender: Any) {
        
    }
    
    @IBAction func xcitedSecondEdited(_ sender: Any) {
        
    }
    
    @IBAction func xcitedThirdEdited(_ sender: Any) {
    }
    
    func setUpSearchFields() {
        self.gtudeFirstEntry.inlineMode = true
        self.gtudeFirstEntry.startFilteringAfter = "@"
        self.gtudeFirstEntry.startSuggestingInmediately = true
        self.gtudeFirstEntry.filterStrings(names)
        self.gtudeSecondEntry.inlineMode = true
        self.gtudeSecondEntry.startFilteringAfter = "@"
        self.gtudeSecondEntry.startSuggestingInmediately = true
        self.gtudeThirdEntry.filterStrings(names)
        self.gtudeThirdEntry.inlineMode = true
        self.gtudeThirdEntry.startFilteringAfter = "@"
        self.gtudeThirdEntry.startSuggestingInmediately = true
        self.gtudeThirdEntry.filterStrings(names)
        self.xcitedFirstEntry.inlineMode = true
        self.xcitedFirstEntry.startFilteringAfter = "@"
        self.xcitedFirstEntry.startSuggestingInmediately = true
        self.xcitedSecondEntry.filterStrings(names)
        self.xcitedSecondEntry.inlineMode = true
        self.xcitedSecondEntry.startFilteringAfter = "@"
        self.xcitedSecondEntry.startSuggestingInmediately = true
        self.xcitedThirdEntry.filterStrings(names)
        self.xcitedThirdEntry.inlineMode = true
        self.xcitedThirdEntry.startFilteringAfter = "@"
        self.xcitedThirdEntry.startSuggestingInmediately = true
        self.xcitedThirdEntry.filterStrings(names)
        
    }

    
    func generateAttStringAtMentionsHighlighted(inString: String) -> (NSMutableAttributedString, Set<String>) {
        var mentions = Set<String>()
        let pattern = "@((\\w+)(?:\\s\\w+)?)"
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
                    mentions.insert(contact)
                    attrString.addAttribute(NSForegroundColorAttributeName, value: UIColor.orange , range: matchRange)
                }
            }
            
        }
        return (attrString, mentions)
    }
    
    func getDate() -> String {
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "PST")
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss zzz"
        return dateFormatter.string(from: currentDate)
    }
    
    func clearTextLabels() {
        self.gtudeFirstEntry.text = ""
        self.gtudeSecondEntry.text = ""
        self.gtudeThirdEntry.text = ""
        self.xcitedFirstEntry.text = ""
        self.xcitedSecondEntry.text = ""
        self.xcitedThirdEntry.text = ""
    }
    
    func setUpPickerWheel() {
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        self.pickerView.pickerViewStyle = .wheel
        self.pickerView.maskDisabled = false
        self.pickerView.reloadData()
        self.pickerView.selectItem(3)
    }
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func setUpFireBaseAuthUI() {
        self.auth = Auth.auth()
        self.authUI = FUIAuth.defaultAuthUI()
        self.authUI?.delegate = self
        self.authUI?.providers = [FUIPhoneAuth(authUI: self.authUI!),]
        self.authStateListenerHandle = self.auth?.addStateDidChangeListener { (auth, user) in
            guard user != nil else {
                self.loginAction(sender: self)
                return
            }
        }
    }
    
    func numberOfItemsInPickerView(_ pickerView: AKPickerView) -> Int {
        return self.emotions.count
    }
    
    func pickerView(_ pickerView: AKPickerView, titleForItem item: Int) -> String {
        return self.emotions[item]
    }
    
    func initializeContactsOnLoad() {
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
        names.sort()
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

///MARK: Login Extensions
extension NewEntryViewController {
    @IBAction func loginAction(sender: AnyObject) {
        // Present the default login view controller provided by authUI
        let authViewController = authUI?.authViewController();
        self.present(authViewController!, animated: true, completion: nil)
    }
    
    
    // Implement the required protocol method for FIRAuthUIDelegate
    func authUI(_ authUI: FUIAuth, didSignInWith user: User?, error: Error?) {
        guard let authError = error else { return }
        
        let errorCode = UInt((authError as NSError).code)
        
        switch errorCode {
        case FUIAuthErrorCode.userCancelledSignIn.rawValue:
            print("User cancelled sign-in");
            break
        default:
            let detailedError = (authError as NSError).userInfo[NSUnderlyingErrorKey] ?? authError
            print("Login error: \((detailedError as! NSError).localizedDescription)");
        }
    }
    
}

