//
//  BaseTableTableViewController.swift
//  Movies
//
//  Created by Vincent Bello on 6/6/15.
//  Copyright (c) 2015 Vincent Bello. All rights reserved.
//

import UIKit

class BaseTableViewController: UITableViewController {

    // MARK: Attributes.
    
    let pendingOperations = PendingOperations()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Required if we want to use dequeueReusableCellWithIdentifier(_:)
        tableView.registerClass(MovieTableViewCell.self, forCellReuseIdentifier: GlobalConstants.Identifiers.Base)
        
        // Styling
        self.navigationController?.navigationBar.barTintColor = GlobalConstants.Colors.NavigationBarColor
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
//        self.navigationController?.navigationBar.backIndicatorImage = UIImage(named: "triangle.png")
//        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "triangle.png")
        
        self.navigationController?.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)

        
//        self.navigationController?.navigationBar.translucent = true
        
    }
    
    // MARK: View Life Cycle

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK:

    func configureCell(cell: MovieTableViewCell, forMovie movie: Movie, indexPath: NSIndexPath) {

        cell.movie = movie
        
        cell.textLabel?.attributedText = movie.titleAttributedString()
        //cell.textLabel?.attributedText = cell.getAttributedTitleAndYear(movie.title, year: movie.year)
        cell.detailTextLabel?.text = movie.genres
        
        // badge
        if self.isKindOfClass(AlertsTableViewController) {
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        } else {
            cell.setBadgeAttributes(String(movie.linkCount), backgroundColor: Utils.colorFromLinkCount(movie.linkCount), caption: "link" + (movie.linkCount == 1 ? "" : "s"))
            
            cell.accessoryView = cell.getLinkCountLabel()
        }
        
        UIView.transitionWithView(cell.imageView!, duration: 0.2, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: { cell.imageView?.image = movie.image }, completion: nil)
        
        switch (movie.imageState) {
        case .Failed:
            NSLog("Failed to load image for \(movie.title)")
        case .New:
            self.startOperationsForMovie(movie, indexPath: indexPath)
        default:
            break
        }
        
        cell.tag = indexPath.row
        cell.favoriteButton.addTarget(self, action: "favorites:", forControlEvents: UIControlEvents.TouchUpInside)
        
        if movie.favorited {
            cell.favoriteButton.alpha = 1.0
            cell.favoriteButton.setImage(UIImage(named: "favorite.png"), forState: .Normal)
        } else {
            cell.favoriteButton.alpha = 0.65
            cell.favoriteButton.setImage(UIImage(named: "favorite_empty.png"), forState: .Normal)
        }
        
    }
    
    
    func startOperationsForMovie(movie: Movie, indexPath: NSIndexPath) {
        switch(movie.imageState) {
        case .New:
            startDownloadForRecord(movie, indexPath: indexPath)
        default:
            NSLog("Do nothing")
        }
    }
    
    func startDownloadForRecord(movie: Movie, indexPath: NSIndexPath) {
        if let _ = pendingOperations.downloadsInProgress[indexPath] {
            return
        }
        
        let downloader = MovieImageDownloader(movie: movie)
        
        downloader.completionBlock = {
            if downloader.cancelled {
                return
            }
            dispatch_async(dispatch_get_main_queue(), {
                if self.pendingOperations.downloadsInProgress[indexPath] != nil {
                    self.pendingOperations.downloadsInProgress.removeValueForKey(indexPath)
                    self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .None)
                }
                
            })
        }
        
        pendingOperations.downloadsInProgress[indexPath] = downloader
        pendingOperations.downloadQueue.addOperation(downloader)
        
    }
    
    
    func favorites(sender: AnyObject?) {
        if let button = sender as? UIButton {
            
            let activityIndicator = UIActivityIndicatorView(frame: button.bounds)
            activityIndicator.startAnimating()
            button.addSubview(activityIndicator)

            if let cell = button.superview as? MovieTableViewCell {
                
                let indexPath = NSIndexPath(forRow: cell.tag, inSection: 0)
                
                if cell.movie?.favorited == true { // unfavorite
                    // Assume user is logged in
                    
                    // UIAlertController
                    let alertController = UIAlertController(title: "Removing from favorites", message: "Are you sure you want to remove \"\(cell.movie!.title)\" from your favorites?", preferredStyle: .Alert)
                    let dismissAction = UIAlertAction(title: "Cancel", style: .Default) { (action) in
                        dispatch_async(dispatch_get_main_queue()) {
                            activityIndicator.removeFromSuperview()
                        }
                    }
                    alertController.addAction(dismissAction)
                    let removeAction = UIAlertAction(title: "Remove", style: .Destructive) { (action) in

                        cell.movie!.removeFromFavorites() {
                            dispatch_async(dispatch_get_main_queue()) {
                                activityIndicator.removeFromSuperview()
                                
                                if let controller = self as? FavoritesTableViewController {
                                    // delete row
                                    controller.movies.removeAtIndex(cell.tag)
                                    controller.updateTitle()
                                    controller.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                                } else {
                                    self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .None)
                                }
                            }
                        }
                        
                    }
                    alertController.addAction(removeAction)
                    
                    self.presentViewController(alertController, animated: true, completion: nil)
                    
                } else {
                    
                    if User.isLoggedIn() {
                        cell.movie!.addToFavorites() {
                            dispatch_async(dispatch_get_main_queue()) {
                                activityIndicator.removeFromSuperview()
                                
                                self.tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: cell.tag, inSection: 0)], withRowAnimation: .Fade)

                            }
                        }
                    } else {
                        activityIndicator.removeFromSuperview()
                        // UIAlertController
                        let alertController = UIAlertController(title: "Adding to favorites", message: "You must be logged in to favorite movies.", preferredStyle: .Alert)
                        let dismissAction = UIAlertAction(title: "Cancel", style: .Default, handler: nil)
                        alertController.addAction(dismissAction)
                        let logInAction = UIAlertAction(title: "Log in", style: .Destructive) { (action) in
                            let loginVC = LogInViewController.forLastUsername()
                            self.presentViewController(loginVC, animated: true, completion: nil)
                        }
                        alertController.addAction(logInAction)
                        
                        self.presentViewController(alertController, animated: true, completion: nil)
                    }
                    
                }
            }
            

            
            
            
            
            
            
            
            
        }
        
        
        
        
        
        
        
    }
 

}
