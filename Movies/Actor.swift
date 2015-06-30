//
//  Actor.swift
//  Movies
//
//  Created by Vincent Bello on 6/29/15.
//  Copyright (c) 2015 Vincent Bello. All rights reserved.
//

import UIKit

class Actor: NSObject {
    
    var id : Int = 0
    var person_id : Int = 0
    var name : String = ""
    var photo : String = ""
    var about : String = ""
    var dob : String = ""
    var dod : String = ""
    var imdb_id : String = ""
    var backdrop : String = ""
    var backdrop_id : Int = 0
    var image = UIImage(named: "no_image_found")
    var imageState = PhotoRecordState.New

    init(id: Int, name: String, about: String) {
        self.id = id
        self.name = name
        self.about = about        
    }
    
    init(json: JSON) {
        super.init()
        
        for (keyName: String, subJson: JSON) in json {
            let keyValue : AnyObject
            if keyName == "linkCount" {
                keyValue = subJson.int!
            } else {
                keyValue = subJson.string!
            }
            
            // if property exists
            if self.respondsToSelector(NSSelectorFromString(keyName)) {
                self.setValue(keyValue, forKey: keyName)
            }
        }
    }
}
