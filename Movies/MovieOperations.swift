//
//  Movie.swift
//  Movies
//
//  Created by Vincent Bello on 6/1/15.
//  Copyright (c) 2015 Vincent Bello. All rights reserved.
//

import Foundation
import UIKit

enum PhotoRecordState {
    case New, Downloaded, Failed
}

class PendingOperations {
    
    // values created lazily: aren't initialized until they are accessed (improves performance)
    lazy var downloadsInProgress = [NSIndexPath: NSOperation]()
    lazy var downloadQueue: NSOperationQueue = {
        var queue = NSOperationQueue()
        queue.name = "Download queue"
        queue.maxConcurrentOperationCount = 1
        // can leave this out: probably would improve performance
        return queue
        }()
    
    func clearDownloads() {
        self.downloadsInProgress.removeAll(keepCapacity: false)
    }
}

class MovieImageDownloader: NSOperation {
    
    let movie: Movie
    
    init(movie: Movie) {
        self.movie = movie
    }
    
    override func main() {
        
        if self.cancelled {
            return
        }
        let url = NSURL(string: self.movie.movieImageLink())
        let imageData = NSData(contentsOfURL: url!)
        if self.cancelled {
            return
        }
        
        if imageData?.length > 0 {
            self.movie.image = UIImage(data: imageData!)
            self.movie.imageState = .Downloaded
        } else {
            self.movie.imageState = .Failed
            self.movie.image = UIImage(named: "Failed")
        }
    }
}

class ActorImageDownloader: NSOperation {
    
    let actor: Actor
    
    init(actor: Actor) {
        self.actor = actor
    }
    
    override func main() {
        
        if self.cancelled {
            return
        }
        let url = NSURL(string: self.actor.actorImageLink())
        let imageData = NSData(contentsOfURL: url!)
        if self.cancelled {
            return
        }
        
        if imageData?.length > 0 {
            let image = UIImage(data: imageData!)
            self.actor.image = image
            self.actor.imageState = .Downloaded
        } else {
            self.actor.imageState = .Failed
            self.actor.image = UIImage(named: "Failed")
        }
    }
    
    
    
}







