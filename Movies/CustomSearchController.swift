//
//  CustomSearchBar.swift
//  Movies
//
//  Created by Vincent Bello on 6/7/15.
//  Copyright (c) 2015 Vincent Bello. All rights reserved.
//

import UIKit

class CustomSearchBar: UISearchBar {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.placeholder = "Search Movies, Actors, Directors"
        println("custom search bar")
    }

}
