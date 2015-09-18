//
//  File.swift
//  Movies
//
//  Created by Vincent Bello on 6/8/15.
//  Copyright (c) 2015 Vincent Bello. All rights reserved.
//

import UIKit

class LinkObject: NSObject {
    
    var id : Int = 0
    var type : String = ""
    var link : String = ""
    var rent : String = ""
    var buy : String = ""
    var timestamp : String = ""
    
    // Link-specific attributes. It shouldn't be necessary to create a subclass for every single link type.
    var itunesId : String = ""
    var asin : String = ""
    
    
    
    init(JSONDictionary: NSDictionary) {
        super.init()
        
        // loop
        for (key, value) in JSONDictionary {
            let keyName = key as! String
            let keyValue = value as! String
            
            // if property exists
            if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                self.setValue(keyValue, forKey: keyName)
            }
        }
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
    
    // Assumes that there is a link.
    func pricesString() -> NSMutableAttributedString {
        
        let attrStr = NSMutableAttributedString()
        
        let boldAttrs = [NSFontAttributeName: UIFont.boldSystemFontOfSize(13)]
        let hdAttrs = [NSFontAttributeName: UIFont.boldSystemFontOfSize(8.5), NSForegroundColorAttributeName: GlobalConstants.Colors.DefaultColor, NSBaselineOffsetAttributeName: 6]
        switch (self.type) {
        case "itunes", "amazon", "google_play":
            if (count(self.rent) == 0 && count(self.buy) == 0) {
                attrStr.appendString("Follow link")
            } else {
                if (count(self.rent) > 0) {
                    var rentComponents = self.rent.componentsSeparatedByString("|")
                    if count(rentComponents[0]) > 0 {
                        attrStr.appendString("Rent: ")
                        attrStr.appendAttributedString(NSMutableAttributedString(string: "$\(rentComponents[0])\n", attributes: boldAttrs))
                        if count(rentComponents[1]) > 0 {
                            attrStr.appendString("Rent")
                            attrStr.appendAttributedString(NSMutableAttributedString(string: "HD", attributes: hdAttrs))
                            attrStr.appendString(": ")
                            attrStr.appendAttributedString(NSMutableAttributedString(string: "$\(rentComponents[1])", attributes: boldAttrs))
                            if count(self.buy) > 1 { attrStr.appendString("\n") }
                        }
                    }
                }
                if (count(self.buy) > 0) {
                    var buyComponents = self.buy.componentsSeparatedByString("|")
                    if count(buyComponents[0]) > 0 {
                        attrStr.appendString("Buy: ")
                        attrStr.appendAttributedString(NSMutableAttributedString(string: "$\(buyComponents[0])\n", attributes: boldAttrs))
                        if count(buyComponents[1]) > 0 {
                            attrStr.appendString("Buy")
                            attrStr.appendAttributedString(NSMutableAttributedString(string: "HD", attributes: hdAttrs))
                            attrStr.appendString(": ")
                            attrStr.appendAttributedString(NSMutableAttributedString(string: "$\(buyComponents[1])", attributes: boldAttrs))
                        }
                    }
                }
            }
        case "netflix":
            attrStr.appendString("Streaming\n(Subscription)")
        case "crackle":
            attrStr.appendString("Streaming\n(Ads)")
        case "youtube":
            attrStr.appendString("Follow link")
        default:
            print("weird type: \(self.type)")
            break
        }
        return attrStr
    }
    
    // Assumes that there is a link. Will return two links, one that is app specific and one that will open on Safari otherwise.
    func app_link() -> [String] {
        
        switch self.type {
        case "itunes":
            let appSpecific = count(self.itunesId) > 0 ? GlobalConstants.Links.ItunesPrefix + self.itunesId : self.link
            return [appSpecific]
        case "amazon", "netflix":
            let scheme = self.type == "amazon" ? GlobalConstants.URLSchemes.Amazon : GlobalConstants.URLSchemes.Netflix
            var appSpecific = self.link.stringByReplacingOccurrencesOfString("https://", withString: scheme)
            appSpecific = appSpecific.stringByReplacingOccurrencesOfString("http://", withString: scheme)
            return [appSpecific, self.link]
        case "crackle":
            let appSpecific = self.link.stringByReplacingOccurrencesOfString("https://", withString: "crackle://")
            return [appSpecific, self.link]
        default:
            return [self.link]
        }
    }
    
    
}

