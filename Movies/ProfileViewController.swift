//
//  ProfileViewController.swift
//  Movies
//
//  Created by Vincent Bello on 7/15/15.
//  Copyright © 2015 Vincent Bello. All rights reserved.
//

import UIKit

class ProfileViewController: BaseTableViewController, CommunicationControllerLogIn {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBAction func logOut(sender: AnyObject) {
        
        let alertController = UIAlertController(title: "Logging out", message: "Are you sure you want to log out?", preferredStyle: .Alert)
        alertController.view.tintColor = UIColor.darkTextColor()
        let dismissAction = UIAlertAction(title: "Cancel", style: .Default, handler: nil)
        alertController.addAction(dismissAction)
        let logOutAction = UIAlertAction(title: "Log out", style: .Destructive) { (action) in
            self.logOutActions()
        }
        alertController.addAction(logOutAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    
    
    var currentUser: User!
    
    class func forUser(user: User) -> ProfileViewController {
        let storyboard = UIStoryboard(name: GlobalConstants.StoryboardName, bundle: nil)
        let viewController = storyboard.instantiateViewControllerWithIdentifier("ProfileViewController") as! ProfileViewController
        viewController.currentUser = user
        
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let item = self.tabBarController?.tabBar.items?[2] {
            item.selectedImage = UIImage(named: "user_selected.png")
        }

        self.navigationController?.view.setUpLoadingIndicator("Loading user...")
        //self.setUpLoadingIndicator("Loading popular movies...", offsetY: 80)

    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // Check if user is logged in
        if User.isLoggedIn() {
            self.currentUser = User.fetch()
            setUpElements()
        } else {
            self.showLogin()
        }
        
    }
    
    func setUpElements() {

        self.profileImageView.imageFromUrl(currentUser.imageLink())
        self.nameLabel.text = currentUser.fullName()
        self.emailLabel.text = currentUser.email
        
        self.navigationController?.view.removeLoadingIndicator()
        
    }
    
    func showLogin() {
        
        let loginVC = LogInViewController.forLastUsername()
        loginVC.delegate = self
        
        self.presentViewController(loginVC, animated: true, completion: nil)
        
    }
    
    func sendUser(user: User) {
        self.currentUser = user
        self.setUpElements()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func logOutActions() {
        currentUser.logOut()
        
        self.showLogin()
    }
    
//    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        switch indexPath.section {
//        case 0:
//            
//            
//            
//            
//            
//        }
//    }

//    // MARK: - Table view data source
//
//    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }
//
//    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 0
//    }

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation
    */
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let favoritesScene = segue.destinationViewController as? FavoritesTableViewController {
            favoritesScene.userID = currentUser.id
        } else if let alertsScene = segue.destinationViewController as? AlertsTableViewController {
            alertsScene.userID = currentUser.id
        }
        
    }
}
