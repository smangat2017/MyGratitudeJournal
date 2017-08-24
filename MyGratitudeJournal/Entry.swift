//
//  Entry.swift
//  MyGratitudeJournal
//
//  Created by Simar Mangat on 8/21/17.
//  Copyright © 2017 Simar Mangat. All rights reserved.
//

import Foundation

class Entry {
    
    private var _gtudeFirstEntry: String!
    private var _gtudeSecondEntry: String!
    private var _gtudeThirdEntry: String!
    private var _xcitedFirstEntry: String!
    private var _xcitedSecondEntry: String!
    private var _xcitedThirdEntry: String!
    private var _entryEmotion: String!
    private var _entryDate : Date!
    
    var gtudeFirstEntry: String {
        return _gtudeFirstEntry
    }
    
    var gtudeSecondEntry: String {
        return _gtudeSecondEntry
    }
    
    var gtudeThirdEntry: String {
        return _gtudeThirdEntry
    }
    
    var xcitedFirstEntry: String {
        return _xcitedFirstEntry
    }
    
    var xcitedSecondEntry: String {
        return _xcitedSecondEntry
    }
    
    var xcitedThirdEntry: String {
        return _xcitedThirdEntry
    }
    
    var entryEmotion: String {
        return _entryEmotion
    }
    
    var entryDate: Date {
        return _entryDate
    }
    
    init(gfirst: String, gsecond: String, gthird: String, xfirst: String, xsecond: String, xthird: String, emotion: String, date: Date){
        self._gtudeFirstEntry = gfirst
        self._gtudeSecondEntry = gsecond
        self._gtudeThirdEntry = gthird
        self._xcitedFirstEntry = xfirst
        self._xcitedSecondEntry = xsecond
        self._xcitedThirdEntry = xthird
        self._entryEmotion = emotion
        self._entryDate = date
    }
}
