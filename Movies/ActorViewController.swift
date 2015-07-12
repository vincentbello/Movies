//
//  ActorViewController.swift
//  Movies
//
//  Created by Vincent Bello on 7/7/15.
//  Copyright (c) 2015 Vincent Bello. All rights reserved.
//

import UIKit

class ActorViewController: UIViewController {
    
    
    @IBOutlet weak var backdropImageView: UIImageView!
    @IBOutlet weak var taglineLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var informationLabel: UILabel!
    @IBOutlet weak var aboutLabel: UITextView!

    @IBOutlet weak var containerViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var informationViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var contentViewHeightConstraint: NSLayoutConstraint!
    
    var currentActor: Actor!
    var linksTableViewController = LinksTableViewController()
    
    // MARK: Factory Methods
    
    class func forActor(actor: Actor) -> ActorViewController {
        let storyboard = UIStoryboard(name: GlobalConstants.StoryboardName, bundle: nil)
        let viewController = storyboard.instantiateViewControllerWithIdentifier("ActorViewController") as! ActorViewController
        viewController.currentActor = actor
        
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setUpViewElements()
    }
    
    override func viewDidLayoutSubviews() {
        
        let containerHeight = CGFloat(2000)
        let informationViewHeight = max(aboutLabel.maxYinParentFrame(), imageView.maxYinParentFrame())
        let contentViewHeight = backdropImageView.frame.height + informationViewHeight + containerHeight
        
        self.informationViewHeightConstraint.constant = informationViewHeight
        self.view.layoutIfNeeded()
        
        self.containerViewHeightConstraint.constant = containerHeight
        self.view.layoutIfNeeded()
        
        self.contentViewHeightConstraint.constant = contentViewHeight
        self.view.layoutIfNeeded()
        
    }
    
    func setUpViewElements() {
        
        backdropImageView.imageFromUrl(currentActor.backdropImageLink())
        if currentActor.imageState == .Downloaded {
            imageView.image = currentActor.image
        } else {
            imageView.imageFromUrl(currentActor.actorImageLink())
        }
        taglineLabel.text = "\(currentActor.backdrop_id)"
        
        nameLabel.text = currentActor.name
        
        informationLabel.text = "\(currentActor.dob) - \(currentActor.dod)"
        
        aboutLabel.text = currentActor.formattedAbout()
        
        let rectObj = imageView.frame
        let textViewOriginY = aboutLabel.frame.origin.y
        let imgOriginY = rectObj.origin.y + rectObj.height
        if imgOriginY > textViewOriginY {
            let exclusionRect = UIBezierPath(rect: CGRectMake(5, 0, rectObj.width, imgOriginY - textViewOriginY - 10))
            aboutLabel.textContainer.exclusionPaths = [exclusionRect]
        }
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        if let filmographyScene = segue.destinationViewController as? FilmographyCollectionViewController {
            filmographyScene.currentActor = currentActor
        }
        
    }

}
