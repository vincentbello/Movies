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
    
    let cellLabels = ["Any", "iTunes Store", "Amazon Instant Video", "Netflix", "YouTube Movies", "Crackle", "Google Play Store"]
    
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
        
        let cell = tableView.dequeueReusableCellWithIdentifier(GlobalConstants.Identifiers.Alert, forIndexPath: indexPath)
        
        cell.textLabel?.text = cellLabels[indexPath.row]
//        cell.detailTextLabel
        
        return cell
    }
//    
//    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        return GlobalConstants.TableViewImageHeight + 20
//    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(tableView.indexPathForSelectedRow!, animated: false)
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
