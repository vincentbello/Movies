//
//  MovieTableViewCell.swift
//  Movies
//
//  Created by Vincent Bello on 6/3/15.
//  Copyright (c) 2015 Vincent Bello. All rights reserved.
//

import UIKit

class MovieTableViewCell: UITableViewCell {
    
    var movie: Movie?
    
    var linkCountView: UIView = UIView(frame: CGRectMake(0, 0, 30, 43))
    var linkCountBadge = UILabel()
    var linkCountCaption = UILabel(frame: CGRectMake(0, 33, 30, 10))
    var favoriteButton = UIButton(frame: CGRectMake(15, 52, 30, 30))
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.imageView?.frame = CGRectMake(15, 10, GlobalConstants.TableViewImageWidth, GlobalConstants.TableViewImageHeight)
        self.imageView?.bounds = CGRectMake(15, 10, GlobalConstants.TableViewImageWidth, GlobalConstants.TableViewImageHeight)
        
        self.textLabel?.numberOfLines = 0
        var textLabelFrame = self.textLabel?.frame
        var detailLabelFrame = self.detailTextLabel?.frame
        textLabelFrame?.origin.x = GlobalConstants.TableViewImageWidth + 25
        detailLabelFrame?.origin.x = GlobalConstants.TableViewImageWidth + 25
        self.textLabel?.frame = textLabelFrame!
        self.detailTextLabel?.frame = detailLabelFrame!
        
        linkCountBadge.textColor = UIColor.whiteColor()
        linkCountBadge.textAlignment = NSTextAlignment.Center
        linkCountBadge.font = UIFont(name: linkCountBadge.font.fontName + "-Bold", size: 16)
        linkCountBadge.layer.cornerRadius = 13
        linkCountBadge.clipsToBounds = true
        linkCountBadge.frame = CGRectMake(2, 2, 26, 26)
        
        linkCountCaption.textColor = GlobalConstants.Colors.LightGrayColor
        linkCountCaption.textAlignment = NSTextAlignment.Center
        linkCountCaption.font = UIFont(name: linkCountCaption.font.fontName, size: 12)
        
        // add favorite
        favoriteButton.backgroundColor = UIColor.whiteColor()
        favoriteButton.layer.borderColor = GlobalConstants.Colors.DefaultColor.CGColor
        favoriteButton.layer.borderWidth = 1.0
        favoriteButton.layer.cornerRadius = 3.0
        
        self.addSubview(favoriteButton)
        
        
    }
    
    func setBadgeAttributes(text: String, backgroundColor: UIColor, caption: String) {
        linkCountBadge.text = text
        linkCountBadge.backgroundColor = backgroundColor
        linkCountCaption.text = caption
    }
    
    func getLinkCountLabel() -> UIView {
        linkCountView.addSubview(linkCountBadge)
        linkCountView.addSubview(linkCountCaption)
        return linkCountView
    }

}
