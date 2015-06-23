//
//  LinkTableViewCell.swift
//  Movies
//
//  Created by Vincent Bello on 6/23/15.
//  Copyright (c) 2015 Vincent Bello. All rights reserved.
//

import UIKit

class LinkTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        //        self.detailTextLabel?.layer.borderColor = UIColor.blueColor().CGColor
        //        self.detailTextLabel?.layer.borderWidth = 2.0
        
        println("before: \(self.textLabel?.frame)")
        let textLabelHeight = self.textLabel?.frame.height
        self.textLabel?.frame.origin.y = (GlobalConstants.Links.Cells.Height - textLabelHeight!) / 2
        
        println(self.textLabel?.frame)
    }

}
