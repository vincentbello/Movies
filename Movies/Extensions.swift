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
    
    func setUpLoadingIndicator(message: String = "Loading...", offsetY: CGFloat = 0) {
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        let loadingView = UIView(frame: self.frame)
        loadingView.backgroundColor = UIColor.whiteColor()
        loadingView.tag = GlobalConstants.LoadingTag
        
        let loadingLabel = UILabel()
        loadingLabel.text = message
        loadingLabel.textColor = UIColor.darkTextColor()
        loadingLabel.font = UIFont.systemFontOfSize(15.0)
        
        loadingView.addSubview(loadingLabel)
        
        loadingLabel.sizeToFit()
        
        loadingLabel.center = CGPointMake(self.center.x, self.center.y - offsetY)
        
        self.userInteractionEnabled = false
        
        self.addSubview(loadingView)
        
    }
    
    func removeLoadingIndicator() {
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        
        self.userInteractionEnabled = true
        
        for view in self.subviews {
            if view.tag == GlobalConstants.LoadingTag {
                view.removeFromSuperview()
                break
            }
        }
        
    }
    
    func bounceIn() {
        
        self.transform = CGAffineTransformMakeScale(0.8, 0.8)
        self.hidden = false
        
        UIView.animateWithDuration(0.3, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.0, options: UIViewAnimationOptions.CurveLinear, animations: {
            self.transform = CGAffineTransformMakeScale(1, 1)
            }, completion: nil)
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
                    print("error downloading image with url: \(urlString)")
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
    
    override func setUpLoadingIndicator(message: String = "Loading...", offsetY: CGFloat = 0) {
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        let tblViewFooter = UIView(frame: CGRectZero)
        tblViewFooter.backgroundColor = UIColor.whiteColor()
        
        let loadingLabel = UILabel()
        loadingLabel.text = message
        loadingLabel.textColor = UIColor.darkTextColor()
        loadingLabel.font = UIFont.systemFontOfSize(15.0)
        
        tblViewFooter.addSubview(loadingLabel)
        
        loadingLabel.sizeToFit()
        
        loadingLabel.center = CGPointMake(self.center.x, self.center.y - offsetY)
                
        self.userInteractionEnabled = false
        self.tableFooterView = tblViewFooter
        
    }
    
    override func removeLoadingIndicator() {
        self.tableFooterView = UIView()
        self.userInteractionEnabled = true
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
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


extension UINavigationController {
    
    public func presentTransparentNavigationBar() {
        navigationBar.setBackgroundImage(UIImage(), forBarMetrics:UIBarMetrics.Default)
        navigationBar.translucent = true
        navigationBar.shadowImage = UIImage()
        setNavigationBarHidden(false, animated:true)
    }
    
    public func hideTransparentNavigationBar() {
        setNavigationBarHidden(true, animated:false)
        navigationBar.setBackgroundImage(UINavigationBar.appearance().backgroundImageForBarMetrics(UIBarMetrics.Default), forBarMetrics:UIBarMetrics.Default)
        navigationBar.translucent = UINavigationBar.appearance().translucent
        navigationBar.shadowImage = UINavigationBar.appearance().shadowImage
    }
    
}

extension UIButton {
    
    func addActivityIndicator() {
        let dimension = self.frame.height - 10
        let frame = CGRectMake(self.frame.width - dimension - 5, 5, dimension, dimension)
        let activityIndicator = UIActivityIndicatorView(frame: frame)
        activityIndicator.startAnimating()
        self.addSubview(activityIndicator)
    }
    
    func removeActivityIndicator() {
        for view in self.subviews {
            if view.isKindOfClass(UIActivityIndicatorView) {
                view.removeFromSuperview()
                break
            }
        }
    }
    
    
    
    
}



