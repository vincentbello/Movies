//
//  Alert.swift
//  Movies
//
//  Created by Vincent Bello on 7/21/15.
//  Copyright © 2015 Vincent Bello. All rights reserved.
//

import UIKit

class Alert: NSObject {

    var user_id : Int = 0
    var id : Int = 0
    var any : Bool = false
    var itunes : Bool = false
    var amazon : Bool = false
    var netflix : Bool = false
    var youtube : Bool = false
    var crackle : Bool = false
    var google_play : Bool = false
    
    override init() {
        super.init()
    }
    
    init(json: JSON) {
        super.init()
        
        for (keyName, subJson): (String, JSON) in json {
            let keyValue : AnyObject
            if keyName == "user_id" || keyName == "id" {
                keyValue = subJson.string!
            } else {
                keyValue = subJson.string! == "1" ? true : false
            }
            
            // if property exists
            if self.respondsToSelector(NSSelectorFromString(keyName)) {
                self.setValue(keyValue, forKey: keyName)
            }
        }
    }
    
    
}
