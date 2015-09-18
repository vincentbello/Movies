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
    
    var animator: UIDynamicAnimator!
    
    @IBAction func doneButtonClicked(sender: AnyObject) {
        self.dismissController()
    }
    
    @IBAction func touchedScreen(sender: AnyObject) {
        self.showHideCaption()
    }
    
    @IBAction func zoom(sender: AnyObject) {
        
        if let gesture = sender as? UIPinchGestureRecognizer {
            if gesture.state == .Ended || gesture.state == .Changed {
                
                let currentScale = self.imageView.frame.size.width / self.imageView.bounds.size.width
                let newScale = max(min(3, currentScale * gesture.scale), 1)
                
                let transform = CGAffineTransformMakeScale(newScale, newScale)
                
                self.imageView.transform = transform
                gesture.scale = 1
                
                
                
            }
        }

    }

    @IBAction func doubleTap(sender: AnyObject) {
        let currentScale = self.imageView.frame.size.width / self.imageView.bounds.size.width
        let newScale = currentScale > 1.0 ? CGFloat(1) : CGFloat(2)
        let transform = CGAffineTransformMakeScale(newScale, newScale)
        
        UIView.animateWithDuration(Double(0.1), delay: Double(0.0), options: UIViewAnimationOptions.CurveLinear, animations: {
            
            self.imageView.transform = transform
            
            }, completion: { finished in
        })
        
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
            imageView.imageFromUrl(currentMovie.movieImageLink(width: 780))
        } else {
            imageView.hidden = true
            
            backdropImageView.imageFromUrl(currentMovie.backdropImageLink(width: 780))
            backdropImageView.hidden = false
        }
        
        titleYearCaption.text = "\(currentMovie.title) (\(currentMovie.year))"
        
        doneButton.layer.cornerRadius = 5.0
        doneButton.layer.borderColor = UIColor.whiteColor().CGColor
        doneButton.layer.borderWidth = 1.0
        
        NSTimer.scheduledTimerWithTimeInterval(3.0, target: self, selector: "showHideCaption", userInfo: nil, repeats: false)
        
        self.modalPresentationCapturesStatusBarAppearance = true
        
        self.animator = UIDynamicAnimator(referenceView: self.view)
        

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
        print("this is executed!")
        return true
    }
    
    
    @IBAction func swipeDown(recognizer: UIPanGestureRecognizer) {
        
        let translation = recognizer.translationInView(self.view)
        if let view = recognizer.view {
            view.frame.origin.y = view.frame.origin.y + translation.y
            
            let ratio = view.frame.origin.y / view.frame.height
            
            if recognizer.state == UIGestureRecognizerState.Ended {
                let velocity = recognizer.velocityInView(view).y
                // compute ratio
                if ratio > GlobalConstants.DismissRatio && imageView.transform.a == 1.0 {
                    
                    UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: velocity, options: UIViewAnimationOptions.CurveLinear, animations: {
                            view.frame.origin.y = view.frame.height
                        }, completion: { finished in
                            self.dismissViewControllerAnimated(false, completion: nil)
                            //self.dismissController()
                    })

                } else {
                    
                    UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.0, options: UIViewAnimationOptions.CurveLinear, animations: {
                            view.frame.origin.y = 0
                        }, completion: nil)
                }
            }
            
            
        }
        recognizer.setTranslation(CGPointZero, inView: self.view)
        

        
//        let gravityBehavior = UIGravityBehavior(items: [self.view])
//        self.animator.addBehavior(gravityBehavior)
//        
//        let collisionBehavior = UICollisionBehavior(items: [self.view])
//        collisionBehavior.translatesReferenceBoundsIntoBoundary = true
//        self.animator.addBehavior(collisionBehavior)
        
        
        // self.dismissController()

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
