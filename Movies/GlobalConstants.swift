//
//  File.swift
//  Movies
//
//  Created by Vincent Bello on 6/1/15.
//  Copyright (c) 2015 Vincent Bello. All rights reserved.
//

import Foundation
import UIKit

struct GlobalConstants {
    static let APIKey = "09e83e9d105e24932aabefa1092f1123"
    
    static let TableViewImageHeight = CGFloat(72)
    static let TableViewImageWidth = CGFloat(48)
    
    static let DefaultMovieImage = "http://readyto.watch/images/no_image_found.png"
    static let DefaultBackdropImage = "http://readyto.watch/images/no_backdrop.png"
    
    static let StoryboardName = "Main"
    
    struct Links {
        static let LinkArray = ["itunes", "amazon", "netflix", "youtube", "crackle", "google_play"]
        
    }
    
    struct Colors {
        static let DefaultColor = UIColor(red: 194/255, green: 4/255, blue: 39/255, alpha: 1.0)
        static let DefaultDarkerColor = UIColor(red: 128/255, green: 35/255, blue: 27/255, alpha: 1.0)
        static let DefaultDarkestColor = UIColor(red: 111/255, green: 4/255, blue: 22/255, alpha: 1.0)
        //static let LightGray
        static let NavigationBarColor = UIColor(red: 194/255 - 0.12, green: 4/255 - 0.12, blue: 39/255 - 0.12, alpha: 1.0)
        static let LightGrayColor = UIColor(red: 204/255, green: 204/255, blue: 204/255, alpha: 1.0)
        static let DarkGrayColor = UIColor(red: 119/255, green: 119/255, blue: 119/255, alpha: 1.0)
    }
    
    struct TableViewCell {
        static let identifier = "Cell"        
    }
    
    struct TabBar {
        static let Height: CGFloat = 45.0
    }
    
    struct SocialMedia {
        static let FacebookID = "312702495577187"
        static let TwitterHandle = "readytowatch"
        static let GooglePlusID = "101109367661376865300"
        
        static let WebsiteURL = "http://readyto.watch"
        
        
    }
    
}