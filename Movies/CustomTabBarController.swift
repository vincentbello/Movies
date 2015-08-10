//
//  CustomTabBarController.swift
//  Movies
//
//  Created by Vincent Bello on 6/7/15.
//  Copyright (c) 2015 Vincent Bello. All rights reserved.
//

import UIKit

class CustomTabBarController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    override func viewWillLayoutSubviews() {
        if self.tabBar.frame.height != GlobalConstants.TabBar.Height {
            var tabFrame = self.tabBar.frame
            tabFrame.size.height = GlobalConstants.TabBar.Height
            
            tabFrame.origin.y = self.view.frame.size.height - GlobalConstants.TabBar.Height
            self.tabBar.frame = tabFrame
        }
    }
    
    func tabBarController(tabBarController: UITabBarController, shouldSelectViewController viewController: UIViewController) -> Bool {
        
//        if let _ = viewController as? LogInViewController {
//            // attempt to fetch the user
//            if let userData = NSUserDefaults.standardUserDefaults().objectForKey("user") as? NSData {
//                let user = NSKeyedUnarchiver.unarchiveObjectWithData(userData) as! User
//                let profileVC = ProfileViewController.forUser(user)
//                let navigationContr = UINavigationController(rootViewController: profileVC)
////                self.tabBarController?.presentViewController(navigationContr, animated: false, completion: nil)
//                self.presentViewController(navigationContr, animated: false, completion: nil)
//                self.selectedIndex = 2
//                return false
//            }
//        }
        return true
    }
    
//    func tabBarController(tabBarController: UITabBarController, didSelectViewController viewController: UIViewController) {
//        <#code#>
//    }

    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation

    */
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        // Get the new view controller using segue.destinationViewController.
//        print("segueing!")
//        if let destinationController = segue.destinationViewController as? ProfileViewController {
//            print("going to profile view controller")
//            let popularVC = PopularTableViewController()
//            
//            self.presentViewController(popularVC, animated: true, completion: nil)
//                       
//        }
//        // Pass the selected object to the new view controller.
//    }

}
