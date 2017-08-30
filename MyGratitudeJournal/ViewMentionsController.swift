//
//  ViewMentionsController.swift
//  MyGratitudeJournal
//
//  Created by Simar Mangat on 8/26/17.
//  Copyright © 2017 Simar Mangat. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase

class ViewMentionsController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var mentionsView: UITableView!
    
    var mentions = [Mention]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mentionsView.delegate =  self
        mentionsView.dataSource = self
        loadData()
        // Do any additional setup after loading the view.
    }

    func loadData() {
        if Auth.auth().currentUser != nil {
            let ref = Database.database().reference()
            let userPhone = Auth.auth().currentUser!.phoneNumber!
            ref.child("mentions").child("\(userPhone)").observe(.value, with:{ (snapshot) in
                if let mentionDict = snapshot.value as? [String:AnyObject] {
                    self.mentions.removeAll()
                    for (_ , mentionElement) in mentionDict {
                        print(mentionElement)
                        let mention = Mention(mC: (mentionElement["mentionContent"] as? String)!, oU: (mentionElement["originUser"] as? String)!, oN: (mentionElement["originName"] as? String)!, tP: (mentionElement["taggedPhone"] as? String)!, tN: (mentionElement["taggedName"] as? String)!, mD: (mentionElement["mentionDate"] as? String)!)
                        self.mentions.append(mention)
                    }
                    self.mentions.sort(by: {$0.mentionDate > $1.mentionDate})
                }
                self.mentionsView.reloadData()
            }) { (error) in
                print(error.localizedDescription)
            }
        } else {
            print("Authentication Failed")
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "MentionCell", for: indexPath) as? MentionCell {
            let mentioncell = mentions[indexPath.row]
            cell.updateUI(mentioncell)
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mentions.count
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let mention = self.mentions[indexPath.row]
//        performSegue(withIdentifier: "viewEntry", sender: entry)
//    }
//    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let destination = segue.destination as? ViewEntryController {
//            if let journalEntry = sender as? Entry {
//                destination.entry = journalEntry
//            }
//        }
//    }

}
