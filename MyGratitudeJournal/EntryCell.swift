//
//  EntryCell.swift
//  MyGratitudeJournal
//
//  Created by Simar Mangat on 8/22/17.
//  Copyright © 2017 Simar Mangat. All rights reserved.
//

import UIKit

class EntryCell: UITableViewCell {

    @IBOutlet weak var emotionLabel: UILabel!
    @IBOutlet weak var entrySnippet: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func updateUI(entry: Entry) {
        entrySnippet.text = entry.gtudeFirstEntry + " " + entry.gtudeSecondEntry + " " + entry.gtudeThirdEntry + entry.xcitedFirstEntry + " " + entry.xcitedSecondEntry + " " + entry.xcitedThirdEntry
        dateLabel.text = getDate(date: entry.entryDate)
        emotionLabel.text = entry.entryEmotion
    }
    
    func getDate(date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss zzz"
        dateFormatter.timeZone = TimeZone(abbreviation: "PST")
        dateFormatter.locale = NSLocale.current
        let date = dateFormatter.date(from: date)
        dateFormatter.dateFormat = "MM-dd"
        return dateFormatter.string(from: date!)
    }
}
