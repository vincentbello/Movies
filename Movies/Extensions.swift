//
//  Extensions.swift
//  Movies
//
//  Created by Vincent Bello on 6/23/15.
//  Copyright (c) 2015 Vincent Bello. All rights reserved.
//
//  Extensions to common types

import UIKit

extension UIView {
    func maxYinParentFrame() -> CGFloat {
        return self.frame.origin.y + self.frame.size.height
    }
}


extension UISearchBar {
    
    var textField: UITextField? {
        for parent in subviews as! [UIView] {
            for subview in parent.subviews as! [UIView] {
                if let textField = subview as? UITextField {
                    return textField
                }
            }
        }
        return nil
    }
}


extension UIApplication {
    class func tryURL(urls: [String]) {
        let application = UIApplication.sharedApplication()
        for url in urls {
            let urlObj = NSURL(string: url)!
            if application.canOpenURL(urlObj) {
                application.openURL(urlObj)
                return
            }
        }
    }
}


extension NSMutableAttributedString {
    
    func appendString(toAppend: String) {
        self.appendAttributedString(NSMutableAttributedString(string: toAppend))
    }
    
    
}


extension UILabel {
    
    var substituteFontName : String {
        get { return self.font.fontName }
        set {
            if self.font.fontName.rangeOfString("Heavy") == nil {
                self.font = UIFont(name: newValue, size: self.font.pointSize)
            }
        }
    }
    
    var substituteFontNameBold : String {
        get { return self.font.fontName }
        set {
            if self.font.fontName.rangeOfString("Heavy") != nil {
                self.font = UIFont(name: newValue, size: self.font.pointSize)
            }
        }
    }
}

extension UITextField {
    
    var substituteFontName : String {
        get { return self.font.fontName }
        set {
            if self.font.fontName.rangeOfString("Heavy") == nil {
                self.font = UIFont(name: newValue, size: self.font.pointSize)
            }
        }
    }
    
    var substituteFontNameBold : String {
        get { return self.font.fontName }
        set {
            if self.font.fontName.rangeOfString("Heavy") != nil {
                self.font = UIFont(name: newValue, size: self.font.pointSize)
            }
        }
    }
}

