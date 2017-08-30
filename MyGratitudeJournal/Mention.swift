//
//  Mention.swift
//  MyGratitudeJournal
//
//  Created by Simar Mangat on 8/21/17.
//  Copyright © 2017 Simar Mangat. All rights reserved.
//

import Foundation

class Mention {
    
    fileprivate var _mentionContent: String!
    fileprivate var _originUser: String!
    fileprivate var _originName: String!
    fileprivate var _taggedPhone: String!
    fileprivate var _taggedName: String!
    fileprivate var _mentionDate: String!
    
    var mentionContent: String {
        return _mentionContent
    }
    
    var originUser: String {
        return _originUser
    }
    
    var originName: String {
        return _originName
    }
    
    var taggedPhone: String {
        return _taggedPhone
    }
    
    var taggedName: String {
        return _taggedName
    }
    
    var mentionDate: String {
        return _mentionDate
    }

    
    init(mC: String, oU: String, oN: String, tP: String, tN: String, mD: String){
        self._mentionContent = mC
        self._originUser = oU
        self._originName = oN
        self._taggedPhone = tP
        self._taggedName = tN
        self._mentionDate = mD
    }
}
