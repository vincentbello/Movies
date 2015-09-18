//
//  AlertsTableViewController.swift
//  Movies
//
//  Created by Vincent Bello on 7/21/15.
//  Copyright © 2015 Vincent Bello. All rights reserved.
//

//
//  FavoritesTableViewController.swift
//  Movies
//
//  Created by Vincent Bello on 7/16/15.
//  Copyright © 2015 Vincent Bello. All rights reserved.
//

import UIKit

class AlertsTableViewController: BaseTableViewController {
    
    // MARK: Properties
    
    var movies = [Movie]()
    
    var userID: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.separatorInset = UIEdgeInsetsZero

        self.tableView.setUpLoadingIndicator(message: "Loading alerts...", offsetY: 80)
        
        self.refreshControl = ({
            let control = UIRefreshControl()
            control.attributedTitle = NSAttributedString(string: "Pull to refresh")
            control.addTarget(self, action: "fetchMovies", forControlEvents: UIControlEvents.ValueChanged)
            self.tableView.addSubview(control)
            return control
        })()
        
        fetchMovies()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
    }
    
    func fetchMovies() {
        
        let dataSourceURL = "\(GlobalConstants.BaseUrl)alerts.php?key=\(GlobalConstants.APIKey)&user_id=\(userID)"
        RestAPIManager.sharedInstance.getRequest(dataSourceURL) { json in
            
            if json != nil {
                var moviesArr = [Movie]()
                
                for (_, subJson): (String, JSON) in json {
                    
                    let movie = Movie(json: subJson)
                    moviesArr.append(movie)
                }
                
                self.movies = moviesArr
                
                dispatch_async(dispatch_get_main_queue(), {
                    self.tableView.removeLoadingIndicator()
                    self.tableView.reloadData()
                    self.refreshControl!.endRefreshing()
                    self.updateTitle()
                })
            } else {
                print("error")
            }
            
            
        }
    }
    
    func updateTitle() {
        self.navigationItem.title = "Alerts (\(self.movies.count))"
    }
    
    
    // MARK: UITableViewDataSource
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return movies.count
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
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
        
        selectedMovie = movies[indexPath.row]
        
        // set up the detail view controller to show
        let detailViewController = AlertDetailTableViewController.forMovie(selectedMovie)
        
        // Note: should not be necessary byt current iOS 8.0 bug requires it.
        tableView.deselectRowAtIndexPath(tableView.indexPathForSelectedRow()!, animated: false)
        
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
    
//    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        var selectedMovie: Movie
//        
//        // Check to see which table view cell was selected.
//        selectedMovie = movies[indexPath.row]
//        
//        // Set up the detail view controller to show.
////        let detailViewController = MovieViewController.forMovie(selectedMovie)
//        
//        // Note: Should not be necessary but current iOS 8.0 bug requires it.
//        tableView.deselectRowAtIndexPath(tableView.indexPathForSelectedRow!, animated: false)
//        
////        self.navigationController?.pushViewController(detailViewController, animated: true)
//    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
        override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
            
            println("going to segue")
            let indexPath = self.tableView.indexPathForSelectedRow()!
            let selectedMovie = movies[indexPath.row]
            // Get the new view controller using [segue destinationViewController].
            let alertScene = segue.destinationViewController as! AlertDetailTableViewController
            
            alertScene.currentMovie = selectedMovie
            alertScene.userID = userID
        }
    
}
