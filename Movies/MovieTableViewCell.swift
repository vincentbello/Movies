//
//  MovieTableViewCell.swift
//  Movies
//
//  Created by Vincent Bello on 6/3/15.
//  Copyright (c) 2015 Vincent Bello. All rights reserved.
//

import UIKit

class MovieTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.imageView?.frame = CGRectMake(15, 10, GlobalConstants.TableViewImageWidth, GlobalConstants.TableViewImageHeight)
        self.imageView?.bounds = CGRectMake(15, 10, GlobalConstants.TableViewImageWidth, GlobalConstants.TableViewImageHeight)
        
        var textLabelFrame = self.textLabel?.frame
        var detailLabelFrame = self.detailTextLabel?.frame
        textLabelFrame?.origin.x = GlobalConstants.TableViewImageWidth + 25
        detailLabelFrame?.origin.x = GlobalConstants.TableViewImageWidth + 25
        self.textLabel?.frame = textLabelFrame!
        self.detailTextLabel?.frame = detailLabelFrame!
    }

}
