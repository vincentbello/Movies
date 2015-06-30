//
//  ResultsTableController.swift
//  Movies
//
//  Created by Vincent Bello on 6/6/15.
//  Copyright (c) 2015 Vincent Bello. All rights reserved.
//

import UIKit

class ResultsTableController: BaseTableViewController {
    // MARK: Properties
    
    var searchedMovies = [Movie]()
    
    // MARK: View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view
        self.navigationController?.navigationBar.barTintColor = GlobalConstants.Colors.NavigationBarColor
    }
    
    // MARK: UITableViewDataSource
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchedMovies.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(GlobalConstants.Identifiers.Base) as! MovieTableViewCell
        
        let movie = searchedMovies[indexPath.row]
        configureCell(cell, forMovie: movie, indexPath: indexPath)
        
//        UIView.transitionWithView(cell.imageView!, duration: 0.2, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: { cell.imageView?.image = movie.image }, completion: nil)
//        
//        switch (movie.imageState) {
//        case .Failed:
//            NSLog("Failed to load image for \(movie.title)")
//        case .New:
//            self.startOperationsForMovie(movie, indexPath: indexPath)
//        default:
//            break
//        }
        
        return cell
        
    }
    
    
    
}
