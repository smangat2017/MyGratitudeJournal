//
//  Entry.swift
//  MyGratitudeJournal
//
//  Created by Simar Mangat on 8/21/17.
//  Copyright © 2017 Simar Mangat. All rights reserved.
//

import Foundation

class Entry {
    
    private var _firstEntry: String!
    private var _secondEntry: String!
    private var _thirdEntry: String!
    private var _entryDate : Date!
    
    var firstEntry: String {
        return _firstEntry
    }
    
    var secondEntry: String {
        return _secondEntry
    }
    
    var thirdEntry: String {
        return _thirdEntry
    }
    
    var entryDate: Date {
        return _entryDate
    }
    
    init(first: String, second: String, third: String, date: Date){
        self._firstEntry = first
        self._secondEntry = second
        self._thirdEntry = third
        self._entryDate = date
    }
}
