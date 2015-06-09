//
//  MoreViewController.swift
//  Movies
//
//  Created by Vincent Bello on 6/3/15.
//  Copyright (c) 2015 Vincent Bello. All rights reserved.
//

import UIKit

class MoreViewController: UITableViewController {

    @IBOutlet weak var share: UITableViewCell!
    
    @IBOutlet weak var goToFacebook: UITableViewCell!
    @IBOutlet weak var goToTwitter: UITableViewCell!
    @IBOutlet weak var goToGooglePlus: UITableViewCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.barTintColor = GlobalConstants.Colors.NavigationBarColor
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectedCell = self.tableView.cellForRowAtIndexPath(indexPath)
        
        
        if selectedCell == share {
            shareAction()
        } else if selectedCell == goToFacebook {
            UIApplication.tryURL([
                "\(GlobalConstants.URLSchemes.Facebook)profile/\(GlobalConstants.SocialMedia.FacebookID)", // App
                "http://www.facebook.com/\(GlobalConstants.SocialMedia.FacebookID)"
                ])
        } else if selectedCell == goToTwitter {
            UIApplication.tryURL([
                "\(GlobalConstants.URLSchemes.Twitter)user?screen_name=\(GlobalConstants.SocialMedia.TwitterHandle)", // App
                "http://www.twitter.com/\(GlobalConstants.SocialMedia.TwitterHandle)"
                ])
        } else if selectedCell == goToGooglePlus {
            UIApplication.tryURL([
                "\(GlobalConstants.URLSchemes.GooglePlus)plus.google.com/\(GlobalConstants.SocialMedia.GooglePlusID)", // App
                "http://plus.google.com/\(GlobalConstants.SocialMedia.GooglePlusID)"
                ])
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        
    }
    
    func shareAction() {
        
        let textToShare = "Let other people know about readyto.watch so they can use it too."
        
        if let websiteURL = NSURL(string: GlobalConstants.SocialMedia.WebsiteURL) {
            let objectsToShare = [textToShare, websiteURL]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            
            self.presentViewController(activityVC, animated: true, completion: nil)
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

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
