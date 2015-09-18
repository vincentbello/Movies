//
//  AlertDetailTableViewController.swift
//  Movies
//
//  Created by Vincent Bello on 7/21/15.
//  Copyright © 2015 Vincent Bello. All rights reserved.
//

import UIKit

class AlertDetailTableViewController: BaseTableViewController {

    // MARK: Properties
    
    var currentMovie : Movie!
    
    var userID: Int = 0
    
    let cellLabels = [("Any", "any"),
                    ("iTunes Store", "itunes"),
                    ("Amazon Instant Video", "amazon"),
                    ("Netflix", "netflix"),
                    ("YouTube Movies", "youtube"),
                    ("Crackle", "crackle"),
                    ("Google Play Store", "google_play")]
    
    class func forMovie(movie: Movie) -> AlertDetailTableViewController {
        let storyboard = UIStoryboard(name: GlobalConstants.StoryboardName, bundle: nil)
        let viewController = storyboard.instantiateViewControllerWithIdentifier("AlertDetailTableViewController") as! AlertDetailTableViewController
        viewController.currentMovie = movie
        
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Alert for \"\(currentMovie.title)\""
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
    }
    
    // MARK: UITableViewDataSource
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return cellLabels.count
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(GlobalConstants.Identifiers.Alert, forIndexPath: indexPath) as! UITableViewCell
        
        let (longForm, shortForm) = cellLabels[indexPath.row]
        let alertValue = currentMovie.alert.valueForKey(shortForm) as! Bool
        cell.textLabel?.text = longForm
        if let alertSwitch = cell.accessoryView as? UISwitch {
            alertSwitch.on = alertValue
        } else {
            let alertSwitch = UISwitch()
            alertSwitch.on = alertValue
            cell.accessoryView = alertSwitch
        }
//        cell.detailTextLabel
        
        return cell
    }
//    
//    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        return GlobalConstants.TableViewImageHeight + 20
//    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(tableView.indexPathForSelectedRow()!, animated: false)
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
