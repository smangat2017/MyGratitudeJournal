//
//  ViewController.swift
//  MyGratitudeJournal
//
//  Created by Simar Mangat on 8/21/17.
//  Copyright © 2017 Simar Mangat. All rights reserved.
//

import UIKit
import FirebaseDatabase

class NewEntryViewController: UIViewController, UITextFieldDelegate, AKPickerViewDataSource, AKPickerViewDelegate {

    
    let emotions = ["😢", "😤", "😱", "🤗", "😇", "🤔", "🙃", "😎"]
    let emoLabels = ["sad", "mad", "scared", "joyful", "peaceful", "musing",  "silly", "powerful"]

    
    @IBOutlet weak var pickerView: AKPickerView!
    @IBOutlet weak var gtudeFirstEntry: UITextField!
    @IBOutlet weak var gtudeSecondEntry: UITextField!
    @IBOutlet weak var gtudeThirdEntry: UITextField!
    @IBOutlet weak var xcitedFirstEntry: UITextField!
    @IBOutlet weak var xcitedSecondEntry: UITextField!
    @IBOutlet weak var xcitedThirdEntry: UITextField!
    
    
    @IBAction func createNewEntry(_ sender: Any) {
        let currentDate = getDate()
        let entry = Entry(gfirst: gtudeFirstEntry.text!, gsecond: gtudeSecondEntry.text!, gthird: gtudeThirdEntry.text!, xfirst: xcitedFirstEntry.text!, xsecond: xcitedSecondEntry.text!, xthird: xcitedThirdEntry.text!, emotion: self.self.emotions[pickerView.selectedItem], date: currentDate)
        let ref = FIRDatabase.database().reference()
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
        self.tabBarController?.selectedIndex = 1
    }
    
    
    func getDate() -> String {
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "PST")
        dateFormatter.locale = NSLocale.current
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        self.pickerView.pickerViewStyle = .wheel
        self.pickerView.maskDisabled = false
        self.pickerView.reloadData()
        self.pickerView.selectItem(3)
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(NewEntryViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func numberOfItemsInPickerView(_ pickerView: AKPickerView) -> Int {
        return self.emotions.count
    }
    
    func pickerView(_ pickerView: AKPickerView, titleForItem item: Int) -> String {
        return self.emotions[item]
    }

}

