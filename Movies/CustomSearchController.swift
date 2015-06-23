//
//  CustomSearchController.swift
//  Movies
//
//  Created by Vincent Bello on 6/7/15.
//  Copyright (c) 2015 Vincent Bello. All rights reserved.
//

import UIKit

class CustomSearchController: UISearchController {
    
    
    override init(searchResultsController: UIViewController!) {
        super.init(searchResultsController: searchResultsController)
        self.searchBar.sizeToFit()
        self.searchBar.tintColor = GlobalConstants.Colors.DefaultColor
        self.searchBar.placeholder = "Search Movies, Actors, and Directors"
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    required override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}