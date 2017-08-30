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
import PhoneNumberKit


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
    let entrySnippets = ["gtudeFirstEntry","gtudeSecondEntry", "gtudeThirdEntry", "xcitedFirstEntry", "xcitedSecondEntry", "xcitedThirdEntry"]

    
    @IBOutlet weak var pickerView: AKPickerView!
    
    @IBOutlet weak var xcitedThirdEntry: SearchTextField!
    @IBOutlet weak var xcitedSecondEntry: SearchTextField!
    @IBOutlet weak var xcitedFirstEntry: SearchTextField!
    @IBOutlet weak var gtudeThirdEntry: SearchTextField!
    @IBOutlet weak var gtudeSecondEntry: SearchTextField!
    @IBOutlet weak var gtudeFirstEntry: SearchTextField!
    @IBOutlet weak var highlightThirdEntry: SearchTextField!
    @IBOutlet weak var highlightSecondEntry: SearchTextField!
    @IBOutlet weak var highlightFirstEntry: SearchTextField!
    @IBOutlet weak var freeWriteEntry: UIScrollView!
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        if Auth.auth().currentUser != nil {
            self.initializeContactsOnLoad()
            self.displayAlertToGetName()
            self.setUpPickerWheel()
            self.setUpSearchFields()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpFireBaseAuthUI()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(NewEntryViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        NotificationCenter.default.addObserver(self, selector: #selector(NewEntryViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(NewEntryViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func createNewEntry(_ sender: Any) {
//        if Auth.auth().currentUser != nil {
//            let userId = Auth.auth().currentUser!.uid
//            let currentDate = getDate()
//            let entry = Entry(gfirst: gtudeFirstEntry.text!, gsecond: gtudeSecondEntry.text!, gthird: gtudeThirdEntry.text!, xfirst: xcitedFirstEntry.text!, xsecond: xcitedSecondEntry.text!, xthird: xcitedThirdEntry.text!, emotion: self.emotions[pickerView.selectedItem], date: currentDate)
//            let ref = Database.database().reference()
//            let key = ref.child("journalEntries").childByAutoId().key
//            let gratitudeEntry = ["gtudeFirstEntry" : entry.gtudeFirstEntry,
//                                  "gtudeSecondEntry" : entry.gtudeSecondEntry,
//                                  "gtudeThirdEntry" : entry.gtudeThirdEntry,
//                                  "xcitedFirstEntry" : entry.xcitedFirstEntry,
//                                  "xcitedSecondEntry" : entry.xcitedSecondEntry,
//                                  "xcitedThirdEntry" : entry.xcitedThirdEntry,
//                                  "emotion" : entry.entryEmotion,
//                                  "date" : entry.entryDate]
//            let gratitudeUpdate = ["/journalEntries/\(userId)/\(key)": gratitudeEntry]
//            ref.updateChildValues(gratitudeUpdate, withCompletionBlock: { (error, ref) -> Void in
//                self.navigationController?.popViewController(animated: true)
//            })
//            sendMentions()
//            clearTextLabels()
//            self.tabBarController?.selectedIndex = 1            
//        } else {
//            return
//        }
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
    }
    
    @IBAction func gtudeThirdEdited(_ sender: Any) {
        let inString = self.gtudeThirdEntry.text!
        let (newString, references) = generateAttStringAtMentionsHighlighted(inString: inString)
        self.gtudeThirdEntry.attributedText = newString
        self.mentions["gtudeThirdEntry"] = references
    }
    
    @IBAction func xcitedFirstEdited(_ sender: Any) {
        let inString = self.xcitedFirstEntry.text!
        let (newString, references) = generateAttStringAtMentionsHighlighted(inString: inString)
        self.xcitedFirstEntry.attributedText = newString
        self.mentions["xcitedFirstEntry"] = references
    }
    
    @IBAction func xcitedSecondEdited(_ sender: Any) {
        let inString = self.xcitedSecondEntry.text!
        let (newString, references) = generateAttStringAtMentionsHighlighted(inString: inString)
        self.xcitedSecondEntry.attributedText = newString
        self.mentions["xcitedSecondEntry"] = references
    }
    
    @IBAction func xcitedThirdEdited(_ sender: Any) {
        let inString = self.xcitedThirdEntry.text!
        let (newString, references) = generateAttStringAtMentionsHighlighted(inString: inString)
        self.xcitedThirdEntry.attributedText = newString
        self.mentions["xcitedThirdEntry"] = references
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }
    
    func setUpSearchFields() {
        for snippet in self.entrySnippets{
            let entrySnip = self.value(forKey: snippet) as! SearchTextField
            entrySnip.inlineMode = true
            entrySnip.startFilteringAfter = "@"
            entrySnip.startSuggestingInmediately = true
            entrySnip.filterStrings(self.names)
        }
    }

    
    func generateAttStringAtMentionsHighlighted(inString: String) -> (NSMutableAttributedString, Set<String>) {
        var mentions = Set<String>()
        let pattern = "@((\\w+)(?:\\s\\w+)?)"
        let regex = try? NSRegularExpression(pattern: pattern, options: [])
        let range = NSMakeRange(0, inString.characters.count)
        let matches = (regex?.matches(in: inString, options: [], range: range))!
        let attrString = NSMutableAttributedString(string: inString, attributes:nil)
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
        self.authUI?.isSignInWithEmailHidden = true;
        self.authUI?.delegate = self
        self.authUI?.providers = [FUIPhoneAuth(authUI: self.authUI!),]
        self.authStateListenerHandle = self.auth?.addStateDidChangeListener { (auth, user) in
            guard user != nil else {
                self.loginAction(sender: self)
                return
            }
        }
    }
    
    func displayAlertToGetName() {
        if Auth.auth().currentUser?.displayName != nil{
            return
        } else {
            //1. Create the alert controller.
            let alert = UIAlertController(title: "Your Name", message: "Last thing - what is thy name? Let others know who you are when you tag them. :)", preferredStyle: .alert)
            
            let saveAction = UIAlertAction(title: "Save", style: .default, handler: { [weak alert] (_) in
                let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
                let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                changeRequest?.displayName = textField?.text
                changeRequest?.commitChanges { (error) in
                    return
                }
            })
            
            saveAction.isEnabled = false
            alert.addAction(saveAction)

            //2. Add the text field. You can configure it however you need.
            alert.addTextField { (textField) in
                textField.placeholder = "Pooh Bear"
                textField.autocapitalizationType = .words
                textField.clearsOnBeginEditing = true
                NotificationCenter.default.addObserver(forName: NSNotification.Name.UITextFieldTextDidChange, object: textField, queue: OperationQueue.main) { (notification) in
                    saveAction.isEnabled = textField.text!.characters.count > 2
                }
            }
            // 4. Present the alert.
            self.present(alert, animated: true, completion: nil)
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
                        self.names = self.contacts.map{$0.name.lowercased()}
                        self.names.sort()
                    } else {
                        print("Unable to get contacts")
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
    
    func sendMentions() {
        let phoneNumberKit = PhoneNumberKit()
        for (key,values) in self.mentions{
            for person in values {
                let currentUser = Auth.auth().currentUser!
                let textField = self.value(forKey: key) as? SearchTextField
                let unparsedPhone = self.contacts.first(where: {$0.name.lowercased() == person})?.phone
                do {
                    let parsedPhone = try phoneNumberKit.parse(unparsedPhone!)
                    let phoneNumber = phoneNumberKit.format(parsedPhone, toType: .e164)
                    print(currentUser.displayName!)
                    let newMention = Mention(mC: textField!.text!, oU: currentUser.uid, oN: currentUser.displayName!, tP: phoneNumber, tN: person, mD: getDate())
                    let ref = Database.database().reference()
                    let key = ref.child("mentions").childByAutoId().key
                    let mention = ["mentionContent" : newMention.mentionContent,
                                   "originUser" : newMention.originUser,
                                   "originName" : newMention.originName,
                                   "taggedPhone" : newMention.taggedPhone,
                                   "taggedName" : newMention.taggedName]
                    let mentionUpdate = ["/mentions/\(phoneNumber)/\(key)": mention]
                    ref.updateChildValues(mentionUpdate, withCompletionBlock: { (error, ref) -> Void in
                        self.navigationController?.popViewController(animated: true)
                    })
                    ref.child("Users").queryOrdered(byChild: "phoneNumber").queryEqual(toValue: phoneNumber).observeSingleEvent(of: .value, with: { (snapshot) in
                        if snapshot.exists() {
                            
                        } else {
                            print("sending twilio text")
                        }
                    }) { (error) in
                        print(error.localizedDescription)
                    }
                    //check if any user has destination phone number
                    // if yes then send notification
                    // if no then send text
                } catch {
                    print("Couldn't parse number")
                }
            }
        }
    }

}

///MARK: Login Extensions
extension NewEntryViewController {
    @IBAction func loginAction(sender: AnyObject) {
        // Present the default login view controller provided by authUI
        let authViewController = authUI?.authViewController();
        authViewController?.navigationBar.isHidden = true
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
        label.center = CGPoint(x: authViewController!.view.center.x , y: authViewController!.view.center.y)
        label.numberOfLines = 2
        label.textAlignment = .center
        label.text = "Welcome to my gratitude journal! :)"
        authViewController?.view.addSubview(label)
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

