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
    
    func updateUI(_ entry: Entry) {
        entrySnippet.text = entry.highlightFirstEntry + " " + entry.highlightSecondEntry + " " + entry.highlightThirdEntry + " " + entry.gtudeFirstEntry + " " + entry.gtudeSecondEntry + " " + entry.gtudeThirdEntry + entry.xcitedFirstEntry + " " + entry.xcitedSecondEntry + " " + entry.xcitedThirdEntry
        dateLabel.text = getDate(entry.entryDate)
        emotionLabel.text = entry.entryEmotion
    }
    
    func getDate(_ date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss zzz"
        dateFormatter.timeZone = TimeZone(abbreviation: "PST")
        dateFormatter.locale = Locale.current
        let date = dateFormatter.date(from: date)
        dateFormatter.dateFormat = "MM-dd HH:mm"
        return dateFormatter.string(from: date!)
    }
}
