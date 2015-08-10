//
//  MovieViewController.swift
//  Movies
//
//  Created by Vincent Bello on 6/1/15.
//  Copyright (c) 2015 Vincent Bello. All rights reserved.
//

import UIKit

class MovieViewController: UIViewController, UIScrollViewDelegate {

    // MARK: Properties
    
//    @IBOutlet weak var loadingView: UIView!
//    
//    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var backdropImage: UIImageView!
    @IBOutlet weak var taglineLabel: UILabel!
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var synopsisLabel: UITextView!
    
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var unfavoriteButton: UIButton!

    @IBOutlet weak var contentViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var informationViewHeightConstraint: NSLayoutConstraint!
    
//    @IBOutlet weak var linksContainer: UIView!
    var currentMovie: Movie!
    var linksTableViewController = LinksTableViewController()
    
    @IBAction func addToFavorites(sender: AnyObject) {
        
        if User.isLoggedIn() {
            self.currentMovie.addToFavorites() {
                dispatch_async(dispatch_get_main_queue()) {
                    self.favoriteButton.hidden = true
                    self.unfavoriteButton.bounceIn()
                }
            }
        } else {
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
    
    @IBAction func removeFromFavorites(sender: AnyObject) {
        
        // UIAlertController
        let alertController = UIAlertController(title: "Removing from favorites", message: "Are you sure you want to remove \"\(currentMovie.title)\" from your favorites?", preferredStyle: .Alert)
        let dismissAction = UIAlertAction(title: "Cancel", style: .Default, handler: nil)
        alertController.addAction(dismissAction)
        let removeAction = UIAlertAction(title: "Remove", style: .Destructive) { (action) in
            
            self.currentMovie.removeFromFavorites() {
                dispatch_async(dispatch_get_main_queue()) {
                    self.favoriteButton.hidden = false
                    self.unfavoriteButton.hidden = true
                }
            }
            
        }
        alertController.addAction(removeAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)

    }
    
    
    
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
        
        self.navigationController?.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        //self.navigationController?.hidesBarsOnSwipe = true
        
        setUpViewElements()        
    }
    
    func setUpViewElements() {
        
        backdropImage.imageFromUrl(currentMovie.backdropImageLink())
        //backdropImage.image = currentMovie.backdropImage()
        if currentMovie.imageState == .Downloaded {
            movieImage.image = currentMovie.image
        } else {
            movieImage.imageFromUrl(currentMovie.movieImageLink())
        }
        taglineLabel.text = currentMovie.tagline.characters.count > 0 ? "\"\(currentMovie.tagline)\"" : ""
        
        titleLabel.attributedText = currentMovie.titleDetailAttributedString()
        
        infoLabel.text = currentMovie.genInformation()
        
        movieImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "goToImageView:"))
        backdropImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "goToImageView:"))
        
        let rectObj = movieImage.frame
        let textViewOriginY = synopsisLabel.frame.origin.y
        let imgOriginY = rectObj.origin.y + rectObj.height
        if imgOriginY > textViewOriginY {
            let exclusionRect = UIBezierPath(rect: CGRectMake(5, 0, rectObj.width, imgOriginY - textViewOriginY - 20))
            synopsisLabel.textContainer.exclusionPaths = [exclusionRect]
        }
        synopsisLabel.text = currentMovie.synopsis
        
        self.title = "\(currentMovie.title) (\(currentMovie.year))"
        
        if currentMovie.favorited {
            favoriteButton.hidden = true
            unfavoriteButton.hidden = false
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
                
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        
        let containerHeight = CGFloat(1035)
        let informationViewHeight = max(synopsisLabel.maxYinParentFrame(), movieImage.maxYinParentFrame())
        let contentViewHeight = backdropImage.frame.height + informationViewHeight + containerHeight
        
        self.informationViewHeightConstraint.constant = informationViewHeight
        self.view.layoutIfNeeded()
        
        self.containerViewHeightConstraint.constant = containerHeight
        self.view.layoutIfNeeded()
        
        self.contentViewHeightConstraint.constant = contentViewHeight
        self.view.layoutIfNeeded()

        
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func goToImageView(sender: UITapGestureRecognizer) {
        
        // Set up the detail view controller to show.
        let imageViewController = ImageViewController.forMovie(currentMovie)
        imageViewController.isMovieImage = (sender.view == self.movieImage)
        
        self.presentViewController(imageViewController, animated: true, completion: nil)
        
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView.contentOffset.y < 0 {
            
            let scale = min(2, 1 - scrollView.contentOffset.y/200)
            self.backdropImage.transform = CGAffineTransformMakeScale(scale, scale)
            self.backdropImage.frame.origin.y = scrollView.contentOffset.y
        }
//            if scrollView.panGestureRecognizer.translationInView(scrollView.superview).y > 0 {
//                if self.navbarHidden == true {
//                    self.navbarHidden = false
//                }
//
//            } else {
//                if self.navbarHidden == false && scrollView.contentOffset.y > self.navigationController?.navigationBar.frame.height {
//                    self.navbarHidden = true
//                }
//            } 
//        }
        
    }
    
    
    
    
        
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        if let linksScene = segue.destinationViewController as? LinksTableViewController {
            linksScene.currentMovie = currentMovie
        }
        
    }

}
