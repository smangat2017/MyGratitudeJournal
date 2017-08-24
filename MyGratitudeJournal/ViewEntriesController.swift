//
//  ViewEntriesController.swift
//  MyGratitudeJournal
//
//  Created by Simar Mangat on 8/21/17.
//  Copyright © 2017 Simar Mangat. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ViewEntriesController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var entryView: UITableView!
    
    var entries = [Entry]()

    override func viewDidLoad() {
        super.viewDidLoad()
        entryView.delegate =  self
        entryView.dataSource = self
        loadData()
        listenForNewData()
    }
    
    func listenForNewData(){
        let ref = FIRDatabase.database().reference()
        ref.child("journalEntries").observe(.childAdded, with: { snapshot in
            print("THE SHIT IS HAPPENING")
            print(snapshot.value!)
        })
    }
    
    func loadData() {
        self.entries.removeAll()
        let ref = FIRDatabase.database().reference()
        ref.child("journalEntries").observeSingleEvent(of: .value, with:{ (snapshot) in
            if let entryDict = snapshot.value as? [String:AnyObject] {
                for (_ , entryElement) in entryDict {
                    let entry = Entry(gfirst: (entryElement["gtudeFirstEntry"] as? String)!, gsecond:(entryElement["gtudeSecondEntry"] as? String)!, gthird:(entryElement["gtudeThirdEntry"] as? String)!, xfirst: (entryElement["xcitedFirstEntry"] as? String)!, xsecond:
                        (entryElement["xcitedSecondEntry"] as? String)!, xthird:
                        (entryElement["xcitedThirdEntry"] as? String)!, emotion:
                        (entryElement["emotion"] as? String)!, date: (entryElement["date"] as? Date)!)
                    self.entries.insert(entry, at: 0)
                }
            }
            self.entryView.reloadData()
            }) { (error) in
                print(error.localizedDescription)
            }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "EntryCell", for: indexPath) as? EntryCell {
            let entrycell = entries[indexPath.row]
            cell.updateUI(entry: entrycell)
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entries.count
    }
}
