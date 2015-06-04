//
//  MovieViewController.swift
//  Movies
//
//  Created by Vincent Bello on 6/1/15.
//  Copyright (c) 2015 Vincent Bello. All rights reserved.
//

import UIKit

class MovieViewController: CustomUIViewController {
    
    var currentMovie: Movie?

    @IBOutlet weak var backdropImage: UIImageView!
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!

    @IBOutlet weak var synopsisLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        backdropImage.image = currentMovie!.backdropImage()
        movieImage.image = currentMovie!.image
        titleLabel.text = currentMovie!.title
        yearLabel.text = "(" + String(currentMovie!.year) + ")"
        ratingLabel.text = currentMovie!.mpaa
        infoLabel.text = "\(currentMovie!.genRuntime()) - \(currentMovie!.genres) - \(currentMovie!.language)"
        synopsisLabel.text = currentMovie!.synopsis
        
        //movieImage.layer.borderWidth = 2.0
        //movieImage.layer.borderColor = UIColor.whiteColor().CGColor
        synopsisLabel.sizeToFit()
        
        self.title = "\(currentMovie!.title) (\(currentMovie!.year))"
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
