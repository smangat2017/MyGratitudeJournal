//
//  ViewEntryController.swift
//  MyGratitudeJournal
//
//  Created by Simar Mangat on 8/27/17.
//  Copyright © 2017 Simar Mangat. All rights reserved.
//

import UIKit

class ViewEntryController: UIViewController {
    
    
    private var _entry: Entry!
    
    var entry: Entry {
        get {
            return _entry
        } set {
            _entry = newValue
        }
    }
    @IBOutlet weak var emotion: UILabel!
    @IBOutlet weak var gtudeFirstEntry: UITextField!
    @IBOutlet weak var gtudeSecondEntry: UITextField!
    @IBOutlet weak var gtudeThirdEntry: UITextField!
    @IBOutlet weak var xcitedFirstEntry: UITextField!
    @IBOutlet weak var xcitedSecondEntry: UITextField!
    @IBOutlet weak var xcitedThirdEntry: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emotion.text = entry.entryEmotion
        gtudeFirstEntry.text = entry.gtudeFirstEntry
        gtudeSecondEntry.text = entry.gtudeSecondEntry
        gtudeThirdEntry.text = entry.gtudeThirdEntry
        xcitedFirstEntry.text = entry.xcitedFirstEntry
        xcitedSecondEntry.text = entry.xcitedSecondEntry
        xcitedThirdEntry.text = entry.xcitedThirdEntry
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
