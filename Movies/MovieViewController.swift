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
    
    @IBOutlet weak var backdropImage: UIImageView!
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var synopsisLabel: UITextView!
    
    var currentMovie: Movie!
    var test: Bool!
    
    // MARK: Factory Methods
    
//    class func forProduct(product: Product) -> DetailViewController {
//        let storyboard = UIStoryboard(name: StoryboardConstants.storyboardName, bundle: nil)
//        
//        let viewController = storyboard.instantiateViewControllerWithIdentifier(StoryboardConstants.viewControllerIdentifier) as! DetailViewController
//        
//        viewController.product = product
//        println(viewController)
//        
//        return viewController
//    }
    
    
    
    
    class func forMovie(movie: Movie) -> MovieViewController {
        let storyboard = UIStoryboard(name: GlobalConstants.StoryboardName, bundle: nil)
        let viewController = storyboard.instantiateViewControllerWithIdentifier("MovieViewController") as! MovieViewController
        viewController.currentMovie = movie
        viewController.test = true
        
        return viewController        
    }
    
    // MARK: View Life Cycle
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
                
        // Do any additional setup after loading the view.
        backdropImage.image = currentMovie.backdropImage()
        movieImage.image = currentMovie.image
        
        titleLabel.text = currentMovie.title
        yearLabel.text = String(currentMovie.year)
        ratingLabel.text = currentMovie.mpaa
        
        
        /*
        let icon1 = NSTextAttachment()
        icon1.image = UIImage(named: "clock.png")
        let attr1 = NSAttributedString(attachment: icon1)
        let icon2 = NSTextAttachment()
        icon2.image = UIImage(named: "movie.png")
        let attr2 = NSAttributedString(attachment: icon2)
        let icon3 = NSTextAttachment()
        icon3.image = UIImage(named: "bubble.png")
        let attr3 = NSAttributedString(attachment: icon3)
        
        var infoLabelText = NSMutableAttributedString()
        infoLabelText.appendAttributedString(attr1)
        infoLabelText.appendAttributedString(NSMutableAttributedString(string: " \(currentMovie.genRuntime()) - "))
        infoLabelText.appendAttributedString(attr2)
        infoLabelText.appendAttributedString(NSMutableAttributedString(string: " \(currentMovie.genres) - "))
        infoLabelText.appendAttributedString(attr3)
        infoLabelText.appendAttributedString(NSMutableAttributedString(string: " \(currentMovie.language)"))
    
        infoLabel.attributedText = infoLabelText
        */
        
        infoLabel.text = "\(currentMovie.genRuntime()) - \(currentMovie.genres) - \(currentMovie.language)"
        
        let rectObj = movieImage.frame
        let textViewOriginY = synopsisLabel.frame.origin.y
        let imgOriginY = rectObj.origin.y + rectObj.height
        if imgOriginY > textViewOriginY {
            let exclusionRect = UIBezierPath(rect: CGRectMake(0, -5, rectObj.width, imgOriginY - textViewOriginY))
            synopsisLabel.textContainer.exclusionPaths = [exclusionRect]
        }
        synopsisLabel.text = currentMovie.synopsis
        
        self.title = "\(currentMovie.title) (\(currentMovie.year))"
        //synopsisLabel.tintColor =
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
