//
//  ActorCollectionViewCell.swift
//  Movies
//
//  Created by Vincent Bello on 7/1/15.
//  Copyright (c) 2015 Vincent Bello. All rights reserved.
//

import UIKit

class ActorCollectionViewCell: CollectionViewCell {
    
    func configure(forActor actor: Actor) {
        
        self.configureElements()
        
//        self.imageView!.image = actor.image
        
        if actor.imageState != .Downloaded {
            self.imageView?.imageFromUrl(actor.actorImageLink()) { image in
                actor.image = image
                actor.imageState = .Downloaded
            }
        } else {
            self.imageView?.image = actor.image
        }

        
        
        self.nameLabel!.text = actor.name
        self.aboutLabel!.text = actor.character
        
        self.nameLabel!.sizeToFit()
        self.nameLabel!.frame.size.width = 100
        
        self.aboutLabel!.frame = CGRectMake(0, self.nameLabel!.maxYinParentFrame(), 100, 15)
    }
}