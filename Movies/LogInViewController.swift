//
//  LogInViewController.swift
//  Movies
//
//  Created by Vincent Bello on 6/3/15.
//  Copyright (c) 2015 Vincent Bello. All rights reserved.
//

import UIKit

class LogInViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    var lastUsername: String = ""
    var delegate: CommunicationControllerLogIn? = nil
    
    class func forLastUsername(username: String = "") -> LogInViewController {
        let storyboard = UIStoryboard(name: GlobalConstants.StoryboardName, bundle: nil)
        let viewController = storyboard.instantiateViewControllerWithIdentifier("LogInViewController") as! LogInViewController
        viewController.lastUsername = username
        
        return viewController
    }
    
    @IBAction func loginClicked(sender: AnyObject) {
        
        if count(usernameField.text) > 0 && count(passwordField.text) > 0 {
            
            let button = sender as! UIButton
            button.addActivityIndicator()
            
            let body: [String: String] = ["username": usernameField.text!,
                "password": passwordField.text!,
                "key": GlobalConstants.APIKey]
            let dataSourceURL = "\(GlobalConstants.BaseUrl)authenticate.php"
            
            RestAPIManager.sharedInstance.postRequest(dataSourceURL, body: body) { json in
                
                if json != nil {
                    
                    if json["message"] != nil {
                        
                        let alertController = UIAlertController(title: "Whoops!", message: json["message"].string, preferredStyle: UIAlertControllerStyle.Alert)
                        alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                        
                        dispatch_async(dispatch_get_main_queue(), {
                            
                            button.removeActivityIndicator()
                            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                            
                            self.presentViewController(alertController, animated: true, completion: nil)
                        })
                        
                    } else {
                        // Request went through!
                        let user = User(json: json)
                        user.logIn()
                        
                        dispatch_async(dispatch_get_main_queue(), {
                            button.removeActivityIndicator()
                            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                            
                            self.resignFirstResponder()
                            
//                            let profileVC = ProfileViewController.forUser(user)
                            self.delegate?.sendUser(user)
                            
                            self.dismissViewControllerAnimated(false, completion: nil)
                        })
                        
                    }
                }
            }
        }
    }
    
    
    @IBAction func continueWithoutLogin(sender: AnyObject) {
        
        let popularVC = self.storyboard?.instantiateInitialViewController() as? PopularTableViewController
        self.presentViewController(popularVC!, animated: true, completion: nil)
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let item = self.tabBarController?.tabBar.items?[2] as? UITabBarItem {
            item.selectedImage = UIImage(named: "user_selected.png")
        }
        
        usernameField.delegate = self
        passwordField.delegate = self
        
        usernameField.text = lastUsername
        usernameField.becomeFirstResponder()
        
    }

    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == usernameField {
            passwordField.becomeFirstResponder()
            return true
        } else {
            self.view.endEditing(true)
            return false
        }
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.view.endEditing(true)
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

protocol CommunicationControllerLogIn {
    func sendUser(user: User)
}


