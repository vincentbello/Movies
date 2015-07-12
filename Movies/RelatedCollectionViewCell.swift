//
//  RelatedCollectionViewCell.swift
//  Movies
//
//  Created by Vincent Bello on 7/3/15.
//  Copyright (c) 2015 Vincent Bello. All rights reserved.
//

import UIKit

class RelatedCollectionViewCell: CollectionViewCell {
    
    func configure(forMovie movie: Movie) {
        
        self.configureElements()
        
//        self.imageView!.image = movie.image
        if movie.imageState != .Downloaded {
            self.imageView?.imageFromUrl(movie.movieImageLink()) { image in
                movie.image = image
                movie.imageState = .Downloaded
            }
        } else {
            self.imageView?.image = movie.image
        }

        
        
        self.nameLabel!.text = movie.title
        self.aboutLabel!.text = String(movie.year)
        
        self.nameLabel!.sizeToFit()
        self.nameLabel!.frame.size.width = 90
        
        self.aboutLabel!.frame = CGRectMake(0, self.nameLabel!.maxYinParentFrame(), 90, 15)
    }
}