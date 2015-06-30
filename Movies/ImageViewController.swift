//
//  ImageViewController.swift
//  Movies
//
//  Created by Vincent Bello on 6/23/15.
//  Copyright (c) 2015 Vincent Bello. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var backdropImageView: UIImageView!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var captionView: UIView!
    @IBOutlet weak var titleYearCaption: UILabel!
    
    var captionShown = true
    var isMovieImage = true
    
    @IBAction func doneButtonClicked(sender: AnyObject) {
        self.dismissController()
    }
    
    @IBAction func swipedDown(sender: AnyObject) {
        self.dismissController()
    }
    
    @IBAction func touchedScreen(sender: AnyObject) {
        self.showHideCaption()
    }
    
    var currentMovie: Movie!
    
    class func forMovie(movie: Movie) -> ImageViewController {
        let storyboard = UIStoryboard(name: GlobalConstants.StoryboardName, bundle: nil)
        let viewController = storyboard.instantiateViewControllerWithIdentifier("ImageViewController") as! ImageViewController
        viewController.currentMovie = movie
        
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if isMovieImage {
            imageView.image = currentMovie.image
        } else {
            imageView.hidden = true
            
            backdropImageView.image = currentMovie.backdropImage()
            backdropImageView.hidden = false
        }
        //imageView.image = currentMovie.image
        
        titleYearCaption.text = "\(currentMovie.title) (\(currentMovie.year))"
        
        doneButton.layer.cornerRadius = 5.0
        doneButton.layer.borderColor = UIColor.whiteColor().CGColor
        doneButton.layer.borderWidth = 1.0
        
        NSTimer.scheduledTimerWithTimeInterval(3.0, target: self, selector: "showHideCaption", userInfo: nil, repeats: false)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dismissController() {
        self.dismissViewControllerAnimated(true, completion: nil)

    }
    
    func showHideCaption() {
        
        UIView.animateWithDuration(0.2, animations: {
            self.captionView.alpha = self.captionShown ? 0 : 1
            self.doneButton.alpha = self.captionShown ? 0 : 1
            
            }, completion: { finished in
                self.captionView.hidden = self.captionShown
                self.doneButton.hidden = self.captionShown
                self.captionShown = !self.captionShown
                
        })
        
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
