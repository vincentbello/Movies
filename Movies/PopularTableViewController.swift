//
//  MoviesTableViewController.swift
//  Movies
//
//  Created by Vincent Bello on 6/1/15.
//  Copyright (c) 2015 Vincent Bello. All rights reserved.
//

import Foundation
import UIKit

var linkType = "itunes"

let linkTypes = [("itunes", "iTunes Store", "iTunes"),
    ("amazon", "Amazon Instant Video", "Amazon"),
    ("netflix", "Netflix", "Netflix"),
    ("youtube", "YouTube Movies", "YouTube"),
    ("crackle", "Crackle", "Crackle"),
    ("googleplay", "Google Play Store", "Google Play")]

class PopularTableViewController: UITableViewController, UISearchResultsUpdating {
    
    var movies = [Movie]()
    let pendingOperations = PendingOperations()
    
    var movieSearchController = UISearchController()
    var searchedMovies = [Movie]()    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        //downloadMovies()
        fetchMovieDetails()
        
        // Do any additional setup after loading the view.
        
        self.navigationController?.navigationBar.barTintColor = GlobalConstants.NavigationBarColor
        
        //self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
        self.navigationController?.navigationBar.backIndicatorImage = UIImage(named: "triangle.png")
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "triangle.png")

        self.navigationController?.navigationBar.translucent = true
        
        
        self.tableView.separatorInset = UIEdgeInsetsZero
        
        if let item = self.tabBarController?.tabBar.items?[0] as? UITabBarItem {
            item.selectedImage = UIImage(named: "star_selected.png")
        }
        self.tabBarController?.tabBar.tintColor = GlobalConstants.DefaultColor
        
        
        // bar button
        var linkTypeButton = UIBarButtonItem(image: UIImage(named: "\(linkType).png"), style: UIBarButtonItemStyle.Plain, target: self, action: "changeLinkType:")
        self.navigationItem.rightBarButtonItem = linkTypeButton
        
        
        
        /* ---------------------- */
        
//        self.tableView.delegate = self
//        self.tableView.dataSource = self
//        searchBar.delegate = self
        /* ---------------------- */
        self.movieSearchController = ({
            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self
            controller.searchBar.searchBarStyle = .Default
            controller.dimsBackgroundDuringPresentation = false
            controller.searchBar.sizeToFit()
            controller.searchBar.translucent = false
            controller.searchBar.tintColor = UIColor.whiteColor()
//            controller.navigationItem.rightBarButtonItem?.setTitleTextAttributes([NSFontAttributeName: UIFont.systemFontOfSize(10.0)], forState: .Normal)
//            controller.searchBar.setSearchFieldBackgroundImage(Utils.getImageWithColor(GlobalConstants.DefaultDarkerColor, size: size), forState: .Normal)
            
            controller.searchBar.barTintColor = GlobalConstants.NavigationBarColor
            controller.searchBar.translucent = true
            self.tableView.tableHeaderView = controller.searchBar
            return controller
        })()
        
//        self.view.backgroundColor = GlobalConstants.DefaultColor
        
        
//        var statusBarView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width, height: 20))
//        statusBarView.backgroundColor = GlobalConstants.DefaultColor
//        self.view.addSubview(statusBarView)
        
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchMovieDetails() {
        var dataSourceURL = NSURL(string: getFetchURL())
        let request = NSURLRequest(URL: dataSourceURL!)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { response, data, error in
            if data != nil {
                let jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as! NSDictionary
                
                let moviesArray = jsonResult["movies"] as! NSArray
                var moviesArr = [Movie]()
                for mov in moviesArray {
                    let movDictionary = mov as! NSDictionary
                    var movie = Movie(JSONDictionary: movDictionary)
                    movie = movie.findMovieInArray(Array(Set(self.movies).union(Set(self.searchedMovies))))
                    moviesArr.append(movie)
                }
                if self.movieSearchController.active {
                    self.searchedMovies = moviesArr
                } else {
                    self.movies = moviesArr
                }
                self.tableView.reloadData()
            }
            
            if error != nil {
                let alert = UIAlertView(title: "Oops!", message: error.localizedDescription, delegate: nil, cancelButtonTitle: "OK")
                alert.show()
            }
            
        }
    }
    
    func getFetchURL() -> String {
        if self.movieSearchController.active {
            let query = self.movieSearchController.searchBar.text.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())
            return "http://api.readyto.watch/search.php?q=\(query!)&key=\(GlobalConstants.APIKey)"
        } else {
            return "http://api.readyto.watch/popular.php?type=\(linkType)&key=\(GlobalConstants.APIKey)"
        }
    }
    
    
    
    
    

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return self.movieSearchController.active ? searchedMovies.count : movies.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! MovieTableViewCell

        let movie = self.movieSearchController.active ? searchedMovies[indexPath.row] : movies[indexPath.row]
        
        cell.textLabel?.attributedText = cell.getAttributedTitleAndYear(movie.title, year: movie.year)
        cell.detailTextLabel?.text = movie.genres
        
        cell.imageView?.image = movie.image
        
        switch (movie.imageState) {
        case .Failed:
            NSLog("Failed to load image for \(movie.title)")
        case .New:
            self.startOperationsForMovie(movie, indexPath: indexPath)
        default:
            break
        }
        
        // badge
        cell.setBadgeAttributes(String(movie.linkCount), backgroundColor: Utils.colorFromLinkCount(movie.linkCount), caption: "link" + (movie.linkCount == 1 ? "" : "s"))
        
        cell.accessoryView = cell.getLinkCountLabel()
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return GlobalConstants.TableViewImageHeight + 20
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
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
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */
    
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
    
    func changeLinkType(sender: UIBarButtonItem!) {
        
        let optionMenu = UIAlertController(title: "Link type", message: "Choose a platform to display popular movies.", preferredStyle: .ActionSheet)
        for link in linkTypes {
            let (linkShort, linkLong, linkCaption) = link
            let linkTitle = linkLong + (linkShort == linkType ? " ✓" : "")
            let linkAction = UIAlertAction(title: linkTitle, style: .Default, handler: {(alert: UIAlertAction!) -> Void in
                linkType = linkShort
                sender.image = UIImage(named: "\(linkShort).png")
                self.navigationItem.title = "Popular Movies on \(linkCaption)"
                self.fetchMovieDetails()
            })
            optionMenu.addAction(linkAction)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        optionMenu.addAction(cancelAction)
        
        self.presentViewController(optionMenu, animated: true, completion: nil)
    }
    
    
    
    
    
    
    
    
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        if pendingOperations.downloadsInProgress.count > 0 {
            pendingOperations.clearDownloads()
        }
        //searchedMovies.removeAll(keepCapacity: false)
        
        if count(searchController.searchBar.text) > 0 {
            fetchMovieDetails()
        } else {
            searchedMovies.removeAll(keepCapacity: false)
            self.tableView.reloadData()
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        // Get the new view controller using [segue destinationViewController].
        var movieScene = segue.destinationViewController as! MovieViewController
        
        // Pass the selected object to the new view controller
        if let indexPath = self.tableView.indexPathForSelectedRow() {
            let selectedMovie = movies[indexPath.row]
            movieScene.currentMovie = selectedMovie
        }
    }

}
