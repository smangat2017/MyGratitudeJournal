//
//  ViewController.swift
//  MyGratitudeJournal
//
//  Created by Simar Mangat on 8/21/17.
//  Copyright © 2017 Simar Mangat. All rights reserved.
//

import UIKit
import FirebaseDatabase

class NewEntryViewController: UIViewController, UITextFieldDelegate {

//    @IBOutlet weak var firstEntry: UITextField!
//    @IBOutlet weak var secondEntry: UITextField!
//    @IBOutlet weak var thirdEntry: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(NewEntryViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }

//    @IBAction func entrySubmitted(_ sender: Any) {
//        let currentDate = Date()
//        let entry = Entry(first: firstEntry.text!, second: secondEntry.text!, third: thirdEntry.text!, date: currentDate)
//        let ref = FIRDatabase.database().reference()
//        let key = ref.child("gratitudeEntries").childByAutoId().key
//        let gratitudeEntry = ["firstEntry" : entry.firstEntry,
//                              "secondEntry" : entry.secondEntry,
//                              "thirdEntry" : entry.thirdEntry]
//        let gratitudeUpdate = ["/gratitudeEntries/\(key)": gratitudeEntry]
//        ref.updateChildValues(gratitudeUpdate, withCompletionBlock: { (error, ref) -> Void in
//            self.navigationController?.popViewController(animated: true)
//        })

//    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }

}

