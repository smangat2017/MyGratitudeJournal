//
//  Entry.swift
//  MyGratitudeJournal
//
//  Created by Simar Mangat on 8/21/17.
//  Copyright © 2017 Simar Mangat. All rights reserved.
//

import Foundation

class Entry {
    
    fileprivate var _highlightFirstEntry: String!
    fileprivate var _highlightSecondEntry: String!
    fileprivate var _highlightThirdEntry: String!
    fileprivate var _gtudeFirstEntry: String!
    fileprivate var _gtudeSecondEntry: String!
    fileprivate var _gtudeThirdEntry: String!
    fileprivate var _xcitedFirstEntry: String!
    fileprivate var _xcitedSecondEntry: String!
    fileprivate var _xcitedThirdEntry: String!
    fileprivate var _entryEmotion: String!
    fileprivate var _entryDate : String!
    fileprivate var _freeWrite : String!
    
    var highlightFirstEntry: String {
        return _highlightFirstEntry
    }
    
    var highlightSecondEntry: String {
        return _highlightSecondEntry
    }
    
    var highlightThirdEntry: String {
        return _highlightThirdEntry
    }
    
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
    
    var freeWrite: String {
        return _freeWrite
    }
    
    init(hfirst: String, hsecond: String, hthird: String, gfirst: String, gsecond: String, gthird: String, xfirst: String, xsecond: String, xthird: String, emotion: String, date: String, fw: String){
        self._highlightFirstEntry = hfirst
        self._highlightSecondEntry = hsecond
        self._highlightThirdEntry = hthird
        self._gtudeFirstEntry = gfirst
        self._gtudeSecondEntry = gsecond
        self._gtudeThirdEntry = gthird
        self._xcitedFirstEntry = xfirst
        self._xcitedSecondEntry = xsecond
        self._xcitedThirdEntry = xthird
        self._entryEmotion = emotion
        self._entryDate = date
        self._freeWrite = fw
    }
}
