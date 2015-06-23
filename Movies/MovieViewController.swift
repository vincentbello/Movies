//
//  MovieViewController.swift
//  Movies
//
//  Created by Vincent Bello on 6/1/15.
//  Copyright (c) 2015 Vincent Bello. All rights reserved.
//

import UIKit

class MovieViewController: UIViewController {

    // MARK: Properties
    
//    @IBOutlet weak var loadingView: UIView!
//    
//    @IBOutlet weak var scrollView: UIScrollView!
    
    
    @IBOutlet weak var backdropImage: UIImageView!
    @IBOutlet weak var taglineLabel: UILabel!
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var synopsisLabel: UITextView!
    
    @IBOutlet weak var containerView: UIView!
    
//    @IBOutlet weak var linksContainer: UIView!
    
    var currentMovie: Movie!
    var linksTableViewController = LinksTableViewController()
    
    // MARK: Factory Methods
    
    class func forMovie(movie: Movie) -> MovieViewController {
        let storyboard = UIStoryboard(name: GlobalConstants.StoryboardName, bundle: nil)
        let viewController = storyboard.instantiateViewControllerWithIdentifier("MovieViewController") as! MovieViewController
        viewController.currentMovie = movie
        
        return viewController        
    }
    
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpViewElements()
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            
            dispatch_async(dispatch_get_main_queue()) {
                self.setUpViewElements()
//                self.loadingView.removeFromSuperview()
            }
        }
        
    }
    
    func setUpViewElements() {
        
        backdropImage.image = currentMovie.backdropImage()
        movieImage.image = currentMovie.image
        taglineLabel.text = count(currentMovie.tagline) > 0 ? "\"\(currentMovie.tagline)\"" : ""
        titleLabel.text = currentMovie.title
        yearLabel.text = String(currentMovie.year)
        ratingLabel.text = currentMovie.mpaa
        infoLabel.text = currentMovie.genInformation()
        
        let rectObj = movieImage.frame
        let textViewOriginY = synopsisLabel.frame.origin.y
        let imgOriginY = rectObj.origin.y + rectObj.height
        if imgOriginY > textViewOriginY {
            let exclusionRect = UIBezierPath(rect: CGRectMake(5, -5, rectObj.width, imgOriginY - textViewOriginY))
            synopsisLabel.textContainer.exclusionPaths = [exclusionRect]
        }
        synopsisLabel.text = currentMovie.synopsis
        
        self.title = "\(currentMovie.title) (\(currentMovie.year))"
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
                
        // Do any additional setup after loading the view.
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
        
        
        
        
        
        
//        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { response, data, error in
//            if data != nil {
//                let jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as! NSDictionary
//                
//                let linksArray = jsonResult["links"] as! NSArray
//                var linksArr = [LinkObject]()
//                for linkObj in linksArray {
//                    let linkDictionary = linkObj as! NSDictionary
//                    var link = LinkObject(JSONDictionary: linkDictionary)
//                    linksArr.append(link)
//                }
//                self.linksTableViewController.tableView.delegate = self.linksTableViewController
//                self.linksTableViewController.links = linksArr
//                self.linksTableViewController.tableView.reloadData()
//                
//                dispatch_async(dispatch_get_main_queue()) {
//                    let originalHeight = self.linksContainer.frame.size.height
//                    let tableSize = self.linksTableViewController.tableView.contentSize
//                    
//                    self.linksTableViewController.tableView.frame = CGRectMake(0, 0, tableSize.width, tableSize.height)
//                    self.linksContainer.frame.size = tableSize
//                    self.linksContainer.addSubview(self.linksTableViewController.tableView)
//                    
//                    let oldHeight = self.scrollView.contentSize.height
//                    let addedHeight = oldHeight + tableSize.height - originalHeight
//                    
//                    self.scrollView.contentSize.height = addedHeight
//                    self.scrollView.frame.size.height = addedHeight
//                    self.scrollView.setNeedsDisplay()
//                }
//            }
//            
//            if error != nil {
//                let alert = UIAlertView(title: "Oops!", message: error.localizedDescription, delegate: nil, cancelButtonTitle: "OK")
//                alert.show()
//            }
//            
//        }
        
        /*
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
        */
        
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        if let linksScene = segue.destinationViewController as? LinksTableViewController {
            linksScene.currentMovie = currentMovie
        }
        
    }

}
