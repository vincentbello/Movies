//
//  User.swift
//  Movies
//
//  Created by Vincent Bello on 7/14/15.
//  Copyright © 2015 Vincent Bello. All rights reserved.
//

import UIKit

class User: NSObject, NSCoding {
    
    var id: Int = 0
    var username: String = ""
    var password: String = ""
    var fb_id: String = ""
    var fb_fname: String = ""
    var fb_lname: String = ""
    var email: String = ""
    var image = ""
    var photo = UIImage(named: "no_user_image")
    var imageState = PhotoRecordState.New
    var adult: Int = 0
    var amazon_prime: Int = 1
    var netflix: Int = 1
    //var hash: String = ""
    var resetHash: String = ""
    var token: String = ""
    var active: Int = 1
    
    init(json: JSON) {
        super.init()
        
        for (keyName, subJson): (String, JSON) in json {
            
            let keyValue = subJson.string ?? ""
            
            if keyName == "hash" {
                continue
            }
            
            // if property exists
            if self.respondsToSelector(NSSelectorFromString(keyName)) {
                self.setValue(keyValue, forKey: keyName)
            }
        }
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeInteger(id, forKey: "id")
        aCoder.encodeObject(username, forKey: "username")
        aCoder.encodeObject(password, forKey: "password")
        aCoder.encodeObject(fb_id, forKey: "fb_id")
        aCoder.encodeObject(fb_fname, forKey: "fb_fname")
        aCoder.encodeObject(fb_lname, forKey: "fb_lname")
        aCoder.encodeObject(email, forKey: "email")
        aCoder.encodeObject(image, forKey: "image")
        aCoder.encodeInteger(adult, forKey: "adult")
        aCoder.encodeInteger(amazon_prime, forKey: "amazon_prime")
        aCoder.encodeInteger(netflix, forKey: "netflix")
        aCoder.encodeObject(resetHash, forKey: "resetHash")
        aCoder.encodeObject(token, forKey: "token")
        aCoder.encodeInteger(active, forKey: "active")
    }
    
    required init(coder aDecoder: NSCoder) {
        self.id = aDecoder.decodeIntegerForKey("id")
        self.username = aDecoder.decodeObjectForKey("username") as! String
        self.password = aDecoder.decodeObjectForKey("password") as! String
        self.fb_id = aDecoder.decodeObjectForKey("fb_id") as! String
        self.fb_fname = aDecoder.decodeObjectForKey("fb_fname") as! String
        self.fb_lname = aDecoder.decodeObjectForKey("fb_lname") as! String
        self.email = aDecoder.decodeObjectForKey("email") as! String
        self.image = aDecoder.decodeObjectForKey("image") as! String
        self.adult = aDecoder.decodeIntegerForKey("adult")
        self.amazon_prime = aDecoder.decodeIntegerForKey("amazon_prime")
        self.netflix = aDecoder.decodeIntegerForKey("netflix")
        self.resetHash = aDecoder.decodeObjectForKey("resetHash") as! String
        self.token = aDecoder.decodeObjectForKey("token") as! String
        self.active = aDecoder.decodeIntegerForKey("active")
        
        super.init()
    }
    

    func fullName() -> String {
        if count(self.fb_fname) > 0 && count(self.fb_lname) > 0 {
            return "\(self.fb_fname) \(self.fb_lname)"
        } else {
            return self.username
        }
    }
    
    func hasFB() -> Bool {
        return count(self.fb_id) > 0
    }
    
    func displayName() -> String {
        return self.hasFB() ? self.fb_fname : self.username
    }
    
    func imageLink() -> String {
        if count(self.image) > 0 {
            if self.image.rangeOfString("//graph.facebook.com") != nil {
                return "http:\(self.image)?width=200"
            } else {
                return "http://readyto.watch/\(self.image)"
            }
        }
        return "http://readyto.watch/images/no_user_image.png"
    }
    
    func logIn() {
        let userData = NSKeyedArchiver.archivedDataWithRootObject(self)
        NSUserDefaults.standardUserDefaults().setObject(userData, forKey: "user")
    }
    
    func logOut() {
        NSUserDefaults.standardUserDefaults().removeObjectForKey("user")
    }
    
    static func isLoggedIn() -> Bool {
        if let _ = NSUserDefaults.standardUserDefaults().objectForKey("user") as? NSData {
            return true
        } else {
            return false
        }
    }
    
    static func fetch() -> User {
        let userData = NSUserDefaults.standardUserDefaults().objectForKey("user") as! NSData
        return NSKeyedUnarchiver.unarchiveObjectWithData(userData) as! User
    }
    

}
