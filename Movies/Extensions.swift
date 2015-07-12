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

extension UIImageView {
    public func imageFromUrl(urlString: String, onCompletion: ((UIImage) -> Void)? = nil ) {
        let indicatorX = (self.frame.size.width / 2) - 10
        let indicatorY = (self.frame.size.height / 2) - 10
        let activityIndicator = UIActivityIndicatorView(frame: CGRectMake(indicatorX, indicatorY, 20, 20))
        activityIndicator.startAnimating()
        self.addSubview(activityIndicator)
        
        if let url = NSURL(string: urlString) {
            let request = NSURLRequest(URL: url)
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {
                (response: NSURLResponse?, data: NSData?, error: NSError?) -> Void in
                activityIndicator.removeFromSuperview()
                self.userInteractionEnabled = true
                if let downloadedImage = UIImage(data: data!) {
                    self.image = downloadedImage
                    onCompletion?(downloadedImage)
                } else {
                    print("error downloading image")
                }
            }
        }
    }
}


extension UISearchBar {
    
    var textField: UITextField? {
        for parent in subviews as [UIView] {
            for subview in parent.subviews as [UIView] {
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

extension UITableView {
    
    func reloadSection(section: Int) {
        let indexSet = NSIndexSet(index: section)
//        let range = NSMakeRange(section, 1)
//        let indexSet = NSIndexSet(indexesInRange: range)
        self.reloadSections(indexSet, withRowAnimation: UITableViewRowAnimation.Fade)
    }
    
    func addFooter() {
        let footerView = UIView(frame: CGRectMake(0, 0, self.frame.width, 50))
        footerView.backgroundColor = UIColor.groupTableViewBackgroundColor()
        
        let imageView = UIImageView(image: UIImage(named: "full_logo.png"))
        imageView.frame.size = CGSizeMake(120, 20)
        imageView.center = footerView.center
        
        footerView.addSubview(imageView)
        
        self.tableFooterView = footerView
    }
    
    func setUpLoadingIndicator(offsetY: CGFloat = 0) {
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        let tblViewFooter = UIView(frame: CGRectZero)
        
        let loadingLabel = UILabel()
        loadingLabel.text = "Loading popular movies..."
        loadingLabel.textColor = UIColor.darkTextColor()
        loadingLabel.font = UIFont.systemFontOfSize(15.0)
        
        tblViewFooter.addSubview(loadingLabel)
        
        loadingLabel.sizeToFit()
        
        loadingLabel.center = CGPointMake(self.center.x, self.center.y - offsetY)
        
        self.userInteractionEnabled = false
        self.tableFooterView = tblViewFooter
        
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
    
    func makeBold() {
        self.font = UIFont.boldSystemFontOfSize(self.font.pointSize)
    }
}

extension UITextField {
    
    var substituteFontName : String {
        get { return self.font!.fontName }
        set {
            if self.font!.fontName.rangeOfString("Heavy") == nil {
                self.font = UIFont(name: newValue, size: self.font!.pointSize)
            }
        }
    }
    
    var substituteFontNameBold : String {
        get { return self.font!.fontName }
        set {
            if self.font!.fontName.rangeOfString("Heavy") != nil {
                self.font = UIFont(name: newValue, size: self.font!.pointSize)
            }
        }
    }
}

