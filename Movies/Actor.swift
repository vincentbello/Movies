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
    var about : String = ""
    var dob : String = ""
    var dod : String = ""
    var imdb_id : String = ""
    var backdrop : String = ""
    var backdrop_id : Int = 0
    
    var photo : String = ""
    var image = UIImage(named: "no_actor_found")
    var imageState = PhotoRecordState.New
    
    var character : String = ""

    init(id: Int, name: String, about: String) {
        self.id = id
        self.name = name
        self.about = about        
    }
    
    init(json: JSON) {
        super.init()
        
        for (keyName, subJson): (String, JSON) in json {
            let keyValue = subJson.string!
            
            // if property exists
            if self.respondsToSelector(NSSelectorFromString(keyName)) {
                self.setValue(keyValue, forKey: keyName)
            }
        }
    }
    
    // return UIImage based on link
    func actorImageLink() -> String {
        if self.photo.characters.count > 0 {
            return "http://image.tmdb.org/t/p/w185\(self.photo)"
        } else {
            return GlobalConstants.DefaultActorImage;
        }
    }
    
    func backdropImageLink(width: Int = 396) -> String {
        if self.backdrop.characters.count > 0 {
            return "http://image.tmdb.org/t/p/w\(width)\(self.backdrop)"
        } else {
            return GlobalConstants.DefaultBackdropImage
        }
    }
    
    func formattedAbout() -> String {
        
        var str = self.about.stringByReplacingOccurrencesOfString("From Wikipedia, the free encyclopedia. \n\n", withString: "")
        str = str.stringByReplacingOccurrencesOfString("From Wikipedia, the free encyclopedia.\n\n", withString: "")
        str = str.stringByReplacingOccurrencesOfString("From Wikipedia, the free encyclopedia\n\n", withString: "")
        str.stringByReplacingOccurrencesOfString("\n\n", withString: "\n")
        
//        119: $string = str_replace('From Wikipedia, the free encyclopedia. \n\n', '', $string);
//        120: $string = str_replace('From Wikipedia, the free encyclopedia.', '', $string);
//        121: $string = str_replace('From Wikipedia, the free encyclopedia', '', $string);
        
        
        
        return str
    }
    
    
}
