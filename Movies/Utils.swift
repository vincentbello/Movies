//
//  Utils.swift
//  Movies
//
//  Created by Vincent Bello on 6/3/15.
//  Copyright (c) 2015 Vincent Bello. All rights reserved.
//

import Foundation
import UIKit

class Utils {
    
    static func colorFromLinkCount(linkCount: Int) -> UIColor {
        switch linkCount {
        case 0:
            return UIColor.grayColor()
        case 1:
            return UIColor.redColor()
        case 2:
            return UIColor.orangeColor()
        default:
            return UIColor.greenColor()
        }
    }
    
    
    
}