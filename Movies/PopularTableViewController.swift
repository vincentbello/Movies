//
//  MoviesTableViewController.swift
//  Movies
//
//  Created by Vincent Bello on 6/1/15.
//  Copyright (c) 2015 Vincent Bello. All rights reserved.
//

import UIKit

var linkType = "itunes"

let linkTypes = [("itunes", "iTunes Store"),
    ("amazon", "Amazon Instant Video"),
    ("netflix", "Netflix"),
    ("youtube", "YouTube Movies"),
    ("crackle", "Crackle"),
    ("googleplay", "Google Play Store")]

class PopularTableViewController: UITableViewController, UITextFieldDelegate {
    
    var movies = [Movie]()
    let pendingOperations = PendingOperations()
    
    lazy var searchBar: UISearchBar = UISearchBar(frame: CGRectMake(0, 0, 300, 18))

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
        

        if let field = searchBar.valueForKey("searchField") as? UITextField {
            field.backgroundColor = GlobalConstants.DefaultDarkerColor
            field.textColor = UIColor.whiteColor()
        }
        searchBar.placeholder = "Find Movies"
        var leftNavbarButton = UIBarButtonItem(customView: searchBar)
        self.navigationItem.leftBarButtonItem = leftNavbarButton
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchMovieDetails() {
        var dataSourceURL = NSURL(string: "http://api.readyto.watch/popular.php?type=\(linkType)&key=" + GlobalConstants.APIKey)
        let request = NSURLRequest(URL: dataSourceURL!)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { response, data, error in
            if data != nil {
                let jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as! NSDictionary
                
                let moviesArray = jsonResult["movies"] as! NSArray
                var moviesArr = [Movie]()
                for mov in moviesArray {
                    let movDictionary = mov as! NSDictionary
                    var movie = Movie(JSONDictionary: movDictionary)
                    if (self.movies.count > 0) {
                        movie = movie.findMovieInArray(self.movies)
                    }
                    moviesArr.append(movie)
                }
                self.movies = moviesArr
                self.tableView.reloadData()
            }
            
            if error != nil {
                let alert = UIAlertView(title: "Oops!", message: error.localizedDescription, delegate: nil, cancelButtonTitle: "OK")
                alert.show()
            }
            
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
        return movies.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! MovieTableViewCell
        
        let movie = movies[indexPath.row]
        
        cell.textLabel?.text = "\(movie.title) (\(movie.year))"
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
        var linkCountAccessory = UIView(frame: CGRectMake(0, 0, 30, 43))
        
        var linkCountBadge = UILabel()
        linkCountBadge.text = String(movie.linkCount)
        linkCountBadge.textColor = UIColor.whiteColor()
        linkCountBadge.textAlignment = NSTextAlignment.Center
        linkCountBadge.font = UIFont(name: linkCountBadge.font.fontName + "-Bold", size: 16)
        linkCountBadge.layer.cornerRadius = 13
        linkCountBadge.clipsToBounds = true
        linkCountBadge.frame = CGRectMake(2, 2, 26, 26)
        linkCountBadge.backgroundColor = Utils.colorFromLinkCount(movie.linkCount)
        
        var linkCountCaption = UILabel(frame: CGRectMake(0, 33, 30, 10))
        linkCountCaption.text = "link" + (movie.linkCount == 1 ? "" : "s")
        linkCountCaption.textColor = GlobalConstants.LightGrayColor
        linkCountCaption.textAlignment = NSTextAlignment.Center
        linkCountCaption.font = UIFont(name: linkCountCaption.font.fontName, size: 12)
        
        linkCountAccessory.addSubview(linkCountBadge)
        linkCountAccessory.addSubview(linkCountCaption)
        cell.accessoryView = linkCountAccessory
        
        
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
                self.pendingOperations.downloadsInProgress.removeValueForKey(indexPath)
                self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            })
        }
        
        pendingOperations.downloadsInProgress[indexPath] = downloader
        pendingOperations.downloadQueue.addOperation(downloader)
    }
    
    
    
    
    
    func changeLinkType(sender: UIBarButtonItem!) {
        
        let optionMenu = UIAlertController(title: "Link type", message: "Choose a platform to display popular movies.", preferredStyle: .ActionSheet)
        for link in linkTypes {
            let (linkShort, linkLong) = link
            let linkAction = UIAlertAction(title: linkLong, style: .Default, handler: {(alert: UIAlertAction!) -> Void in
                linkType = linkShort
                sender.image = UIImage(named: "\(linkShort).png")
                self.fetchMovieDetails()
            })
            optionMenu.addAction(linkAction)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        optionMenu.addAction(cancelAction)
        
        self.presentViewController(optionMenu, animated: true, completion: nil)
        
        
        
        
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
