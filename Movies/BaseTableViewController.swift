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
        self.navigationController?.navigationBar.backIndicatorImage = UIImage(named: "triangle.png")
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "triangle.png")
        
//        self.navigationController?.navigationBar.translucent = true
        
        self.tableView.separatorInset = UIEdgeInsetsZero
        
        
    }
    
    // MARK: View Life Cycle

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    // MARK:

    func configureCell(cell: MovieTableViewCell, forMovie movie: Movie, indexPath: NSIndexPath) {

        cell.textLabel?.attributedText = cell.getAttributedTitleAndYear(movie.title, year: movie.year)
        cell.detailTextLabel?.text = movie.genres
        
        // badge
        cell.setBadgeAttributes(String(movie.linkCount), backgroundColor: Utils.colorFromLinkCount(movie.linkCount), caption: "link" + (movie.linkCount == 1 ? "" : "s"))
        
        cell.accessoryView = cell.getLinkCountLabel()
        
        UIView.transitionWithView(cell.imageView!, duration: 0.2, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: { cell.imageView?.image = movie.image }, completion: nil)
        
        switch (movie.imageState) {
        case .Failed:
            NSLog("Failed to load image for \(movie.title)")
        case .New:
            self.startOperationsForMovie(movie, indexPath: indexPath)
        default:
            break
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
        if let downloadOperation = pendingOperations.downloadsInProgress[indexPath] {
            return
        }
        
        let downloader = ImageDownloader(movie: movie)
        
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
 

}
