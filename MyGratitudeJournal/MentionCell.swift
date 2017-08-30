//
//  MentionCell.swift
//  MyGratitudeJournal
//
//  Created by Simar Mangat on 8/28/17.
//  Copyright © 2017 Simar Mangat. All rights reserved.
//

import UIKit

class MentionCell: UITableViewCell {

    
    @IBOutlet weak var mentionContent: UILabel!
    @IBOutlet weak var mentionDate: UILabel!
    @IBOutlet weak var taggerLabel: UILabel!
    @IBOutlet weak var ovalInitials: UILabel!
    @IBOutlet weak var ovalImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    func updateUI(_ mention: Mention) {
        self.mentionContent.text = mention.mentionContent
        self.mentionDate.text = getDate(mention.mentionDate)
        self.ovalInitials.text = mention.originName.components(separatedBy: " ").reduce("") { ($0 == "" ? "" : "\($0.characters.first!)") + "\($1.characters.first!)" }
        self.taggerLabel.text = mention.originName
        self.ovalImage.image = UIImage(named: "Oval")
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
