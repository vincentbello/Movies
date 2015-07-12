//
//  FilmographyCollectionViewController.swift
//  Movies
//
//  Created by Vincent Bello on 7/10/15.
//  Copyright © 2015 Vincent Bello. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class FilmographyCollectionViewController: UICollectionViewController {
    
    var currentActor: Actor!

    var movies = [Movie]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
//        override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//            return self.sections[section]
//        }
//        
//        override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//            let headerLabel = UILabel(frame: CGRectMake(15, 15, self.tableView.frame.width, 20))
//            headerLabel.textColor = GlobalConstants.Colors.DefaultColor
//            headerLabel.font = UIFont.boldSystemFontOfSize(18)
//            headerLabel.text = self.tableView(self.tableView, titleForHeaderInSection: section)
//            
//            let headerView = UIView(frame: CGRectMake(0, 0, self.tableView.frame.width, 40))
//            headerView.addSubview(headerLabel)
//            headerView.backgroundColor = UIColor.groupTableViewBackgroundColor()
//            
//            return headerView
//            
//        }
        
        
        
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.registerClass(RelatedCollectionViewCell.self, forCellWithReuseIdentifier: GlobalConstants.Identifiers.FilmographyCollection.Cell)

        // Do any additional setup after loading the view.
        print("fetching movies")
        getMovies()
    }

    func getMovies() {
        
        let dataFetchLink = "http://api.readyto.watch/filmography.php?id=\(currentActor.id)&key=\(GlobalConstants.APIKey)"
        
        RestAPIManager.sharedInstance.getRequest(dataFetchLink) { json in
            
            if json != nil {
                
                var moviesArr = [Movie]()
                for (_, subJson): (String, JSON) in json {
                    let movie = Movie(json: subJson)
                    moviesArr.append(movie)
                }
                
                self.movies = moviesArr
                
                dispatch_async(dispatch_get_main_queue(), {
                    self.collectionView?.reloadData()
                })
                
            } else {
                print("error loading filmography")
            }
        }

    }
    
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return movies.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(GlobalConstants.Identifiers.FilmographyCollection.Cell, forIndexPath: indexPath) as! RelatedCollectionViewCell
    
        // Configure the cell
        let movie = self.movies[indexPath.row]
        cell.configure(forMovie: movie)
    
        return cell
    }
    
    
    

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */

}
