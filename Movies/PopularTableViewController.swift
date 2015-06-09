//
//  MoviesTableViewController.swift
//  Movies
//
//  Created by Vincent Bello on 6/1/15.
//  Copyright (c) 2015 Vincent Bello. All rights reserved.
//

import UIKit

var linkType = "itunes"

class PopularTableViewController: BaseTableViewController, UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating
 {
    
    struct SearchControllerRestorableState {
        var wasActive = false
        var wasFirstResponder = false
    }
    
    
    // MARK: Properties
    
    var movies = [Movie]()
//    let pendingOperations = PendingOperations()
    
//    var movieSearchController = UISearchController()
//    var searchedMovies = [Movie]()  
    
    // Search controller to search movies.
    var searchController: CustomSearchController!
    
    // Secondary search results table view.
    var resultsTableController: ResultsTableController!
    
    var restoredState = SearchControllerRestorableState()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Do any additional setup after loading the view.
        
//        self.navigationController?.navigationBar.barTintColor = GlobalConstants.NavigationBarColor
//        
//        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
//        self.navigationController?.navigationBar.backIndicatorImage = UIImage(named: "triangle.png")
//        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "triangle.png")
//
//        self.navigationController?.navigationBar.translucent = true
//        
//        self.tableView.separatorInset = UIEdgeInsetsZero
        
        if let item = self.tabBarController?.tabBar.items?[0] as? UITabBarItem {
            item.selectedImage = UIImage(named: "star_selected.png")
        }
        self.tabBarController?.tabBar.tintColor = GlobalConstants.Colors.DefaultColor
        
        
        // bar button
        var linkTypeButton = UIBarButtonItem(image: UIImage(named: "\(linkType).png"), style: UIBarButtonItemStyle.Plain, target: self, action: "changeLinkType:")
        self.navigationItem.rightBarButtonItem = linkTypeButton
        
        resultsTableController = ResultsTableController()
        
        // We want to be the delegate for our filtered table so didSelectRowAtIndexPath(_:) is called for both tables.
        resultsTableController.tableView.delegate = self
        
        searchController = ({
            let controller = CustomSearchController(searchResultsController: self.resultsTableController)
            controller.searchResultsUpdater = self

            self.tableView.tableHeaderView = controller.searchBar
            
            controller.delegate = self
            controller.searchBar.delegate = self    // So we can monitor text changes + others

            return controller
        })()

        // Search is now just presenting a view controller. As such, normal view controller
        // presentation semantics apply. Namely that presentation will walk up the view controller
        // hierarchy until it finds the root view controller or one that defines a presentation context.
        definesPresentationContext = true
        
        fetchMovieDetails()

        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        //self.tableView.reloadData()
        
        // Restore the search controller's active state.
//        if restoredState.wasActive {
//            searchController.active = restoredState.wasActive
//            restoredState.wasActive = false
//            
//            if restoredState.wasFirstResponder {
//                searchController.searchBar.becomeFirstResponder()
//                restoredState.wasFirstResponder = false
//            }
//        }
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
                    
                    movie = movie.findMovieInArray(Array(Set(self.movies).union(Set(self.resultsTableController.searchedMovies))))
                    moviesArr.append(movie)
                }
                if self.searchController.active {
                    self.resultsTableController.searchedMovies = moviesArr
                    self.resultsTableController.tableView.reloadData()
                } else {
                    self.movies = moviesArr
                    self.tableView.reloadData()
                }
            }
            
            if error != nil {
                let alert = UIAlertView(title: "Oops!", message: error.localizedDescription, delegate: nil, cancelButtonTitle: "OK")
                alert.show()
            }
            
        }
    }
    
    func getFetchURL() -> String {
        if self.searchController.active {
            let query = self.searchController.searchBar.text.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())
            return "http://api.readyto.watch/search.php?q=\(query!)&key=\(GlobalConstants.APIKey)"
        } else {
            return "http://api.readyto.watch/popular.php?type=\(linkType)&key=\(GlobalConstants.APIKey)"
        }
    }
    
    
    func changeLinkType(sender: UIBarButtonItem!) {
        
        let optionMenu = UIAlertController(title: "Link type", message: "Choose a platform to display popular movies.", preferredStyle: .ActionSheet)
        for link in GlobalConstants.Links.LinkTypes {
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
    
    
    // MARK: UISearchResultsUpdating
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        pendingOperations.clearDownloads()
        
        if count(searchController.searchBar.text) > 0 {
            fetchMovieDetails()
        }
        
    }
    
    
    // MARK: UITableViewDataSource
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return movies.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(GlobalConstants.TableViewCell.identifier, forIndexPath: indexPath) as! MovieTableViewCell
        let movie = movies[indexPath.row]
        
        configureCell(cell, forMovie: movie, indexPath: indexPath)
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return GlobalConstants.TableViewImageHeight + 20
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var selectedMovie: Movie
        
        // Check to see which table view cell was selected.
        if tableView == self.tableView {
            selectedMovie = movies[indexPath.row]
        } else {
            selectedMovie = resultsTableController.searchedMovies[indexPath.row]
        }
        
        // Set up the detail view controller to show.
        let detailViewController = MovieViewController.forMovie(selectedMovie)
        
        // Note: Should not be necessary but current iOS 8.0 bug requires it.
        tableView.deselectRowAtIndexPath(tableView.indexPathForSelectedRow()!, animated: false)
        
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    
    // MARK: - UISearchBarDelegate
    
    
    
    
    
    
    
    
    
    
    
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        
//        // Get the new view controller using [segue destinationViewController].
//        var movieScene = segue.destinationViewController as! MovieViewController
//        
//        // Pass the selected object to the new view controller
//        if let indexPath = self.tableView.indexPathForSelectedRow() {
//            let selectedMovie = movies[indexPath.row]
//            movieScene.currentMovie = selectedMovie
//        }
//    }

}
