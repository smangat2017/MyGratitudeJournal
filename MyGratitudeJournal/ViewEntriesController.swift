//
//  ViewEntriesController.swift
//  MyGratitudeJournal
//
//  Created by Simar Mangat on 8/21/17.
//  Copyright © 2017 Simar Mangat. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase


class ViewEntriesController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var entryView: UITableView!
    
    var entries = [Entry]()

    override func viewDidLoad() {
        super.viewDidLoad()
        entryView.delegate =  self
        entryView.dataSource = self
        loadData()
    }
    
    
    func loadData() {
        if Auth.auth().currentUser != nil {
            let ref = Database.database().reference()
            let userId = Auth.auth().currentUser!.uid
            ref.child("journalEntries").child("\(userId)").observe(.value, with:{ (snapshot) in
                if let entryDict = snapshot.value as? [String:AnyObject] {
                    self.entries.removeAll()
                    for (_ , entryElement) in entryDict {
                        let entry = Entry(hfirst: (entryElement["highlightFirstEntry"] as? String)!, hsecond: (entryElement["highlightSecondEntry"] as? String)!, hthird: (entryElement["highlightThirdEntry"] as? String)!,  gfirst: (entryElement["gtudeFirstEntry"] as? String)!, gsecond:(entryElement["gtudeSecondEntry"] as? String)!, gthird:(entryElement["gtudeThirdEntry"] as? String)!, xfirst: (entryElement["xcitedFirstEntry"] as? String)!, xsecond:
                            (entryElement["xcitedSecondEntry"] as? String)!, xthird:
                            (entryElement["xcitedThirdEntry"] as? String)!, emotion:
                            (entryElement["emotion"] as? String)!, date: (entryElement["date"] as? String)!, fw: (entryElement["freeWrite"] as? String)!)
                        self.entries.append(entry)
                    }
                    self.entries.sort(by: {$0.entryDate > $1.entryDate})
                }
                self.entryView.reloadData()
                }) { (error) in
                    print(error.localizedDescription)
                }
        } else {
            print("Authentication Failed")
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "EntryCell", for: indexPath) as? EntryCell {
            let entrycell = entries[indexPath.row]
            cell.updateUI(entrycell)
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entries.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let entry = self.entries[indexPath.row]
        performSegue(withIdentifier: "viewEntry", sender: entry)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ViewEntryController {
            if let journalEntry = sender as? Entry {
                destination.entry = journalEntry
            }
        }
    }
    
}
