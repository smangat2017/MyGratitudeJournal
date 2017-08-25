//
//  Entry.swift
//  MyGratitudeJournal
//
//  Created by Simar Mangat on 8/21/17.
//  Copyright © 2017 Simar Mangat. All rights reserved.
//

import Foundation

class Entry {
    
    fileprivate var _gtudeFirstEntry: String!
    fileprivate var _gtudeSecondEntry: String!
    fileprivate var _gtudeThirdEntry: String!
    fileprivate var _xcitedFirstEntry: String!
    fileprivate var _xcitedSecondEntry: String!
    fileprivate var _xcitedThirdEntry: String!
    fileprivate var _entryEmotion: String!
    fileprivate var _entryDate : String!
    
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
    
    var entryDate: String {
        return _entryDate
    }
    
    init(gfirst: String, gsecond: String, gthird: String, xfirst: String, xsecond: String, xthird: String, emotion: String, date: String){
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
