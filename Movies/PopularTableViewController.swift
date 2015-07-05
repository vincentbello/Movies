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
        
        self.tableView.setUpLoadingIndicator(offsetY: 80)
        
        fetchMovieDetails()

        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
    }
//    
//    func setUpLoadingIndicator() {
//        
//        let tblViewFooter = UIView(frame: CGRectZero)
//        
//        let loadingLabel = UILabel()
//        loadingLabel.text = "Loading popular movies..."
//        loadingLabel.textColor = UIColor.darkTextColor()
//        loadingLabel.font = UIFont(name: GlobalConstants.Fonts.Main.Bold, size: 15.0)
//        
//        tblViewFooter.addSubview(loadingLabel)
//        
//        loadingLabel.sizeToFit()
//        
//        let offsetY = (self.navigationController?.navigationBar)!.frame.height + self.searchController.searchBar.frame.height
//
//        loadingLabel.center = CGPointMake(self.tableView.center.x, self.tableView.center.y - offsetY)
//        
//        self.tableView.userInteractionEnabled = false
//        self.tableView.tableFooterView = tblViewFooter
//        
//    }
    
    func fetchMovieDetails() {
        
        let dataSourceURL = getFetchURL()
        
        RestAPIManager.sharedInstance.getRequest(dataSourceURL) { json in
            
            if json != nil {
                let results = json["movies"]
                var moviesArr = [Movie]()
                
                for (index: String, subJson: JSON) in results {
                    
                    var movie = Movie(json: subJson)
                    movie = movie.findMovieInArray(Array(Set(self.movies).union(Set(self.resultsTableController.searchedMovies))))
                    moviesArr.append(movie)
                }
                
                if self.searchController.active {
                    self.resultsTableController.searchedMovies = moviesArr
                } else {
                    self.movies = moviesArr
                }
                
                dispatch_async(dispatch_get_main_queue(), {
                    self.tableView.userInteractionEnabled = true
                    if self.searchController.active {
                        self.resultsTableController.tableView.reloadData()
                    } else {
                        self.tableView.reloadData()
                    }
                })
            } else {
                println("error")
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
        
        let cell = tableView.dequeueReusableCellWithIdentifier(GlobalConstants.Identifiers.Base, forIndexPath: indexPath) as! MovieTableViewCell
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
