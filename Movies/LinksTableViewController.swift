//
//  LinksTableViewController.swift
//  Movies
//
//  Created by Vincent Bello on 6/8/15.
//  Copyright (c) 2015 Vincent Bello. All rights reserved.
//

import UIKit

class LinksTableViewController: UITableViewController {
    
    var currentMovie: Movie!
    
    var links = [LinkObject]()
    
    var sections = ["Links", "Cast", "Related"]
    
    var cast: [Actor] = [Actor]()
    var relatedMovies: [Movie] = [Movie]()
    var colorsArray: [UIColor] = [UIColor.greenColor(), UIColor.blueColor(), UIColor.yellowColor(), UIColor.blackColor(), UIColor.brownColor(), UIColor.redColor()]
    
    var contentOffsetDictionary: NSMutableDictionary!
    
    
    let pendingActorOperations = PendingOperations()
    let pendingMovieOperations = PendingOperations()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.getLinks()
        self.getCast()
        self.getRelatedMovies()
        self.tableView.addFooter()
        
        self.tableView.separatorInset = UIEdgeInsetsZero
        
        
        self.tableView.registerClass(CastTableViewCell.self, forCellReuseIdentifier: GlobalConstants.Identifiers.CastCollection.Container)
        self.tableView.registerClass(RelatedTableViewCell.self, forCellReuseIdentifier: GlobalConstants.Identifiers.RelatedCollection.Container)
        
        self.contentOffsetDictionary = NSMutableDictionary()

        
    }
    
    func getLinks() {
        
        let dataFetchLink = "http://api.readyto.watch/links.php?id=\(currentMovie.id)&key=\(GlobalConstants.APIKey)"
        
        RestAPIManager.sharedInstance.getRequest(dataFetchLink) { json in
            
            if json != nil {
                let linksArray = json["links"]
                
                var linksArr = [LinkObject]()
                for (_, subJson): (String, JSON) in linksArray {
                    let link = LinkObject(json: subJson)
                    linksArr.append(link)
                }
                
                self.links = linksArr
                
                dispatch_async(dispatch_get_main_queue(), {
                    self.tableView.reloadSection(0)
                })
                
            } else {
                print("error loading links")
            }
        }
        
    }
    
    
    func getCast() {
        
        let dataFetchLink = "http://api.readyto.watch/cast.php?id=\(currentMovie.id)&key=\(GlobalConstants.APIKey)"
        
        RestAPIManager.sharedInstance.getRequest(dataFetchLink) { json in
            
            if json != nil {
                
                var actorsArr = [Actor]()
                for (_, subJson): (String, JSON) in json {
                    let actor = Actor(json: subJson)
                    actorsArr.append(actor)
                }
                self.cast = actorsArr
                
                dispatch_async(dispatch_get_main_queue(), {
                    
                    self.tableView.reloadSection(1)
                    
                })
                
            } else {
                print("error loading cast")
            }
        }
    }
    
    func getRelatedMovies() {
        
        let dataFetchLink = "http://api.readyto.watch/related.php?id=\(currentMovie.id)&key=\(GlobalConstants.APIKey)"
        
        RestAPIManager.sharedInstance.getRequest(dataFetchLink) { json in
            
            if json != nil {
                
                var moviesArr = [Movie]()
                for (_, subJson): (String, JSON) in json {
                    let movie = Movie(json: subJson)
                    moviesArr.append(movie)
                }
                self.relatedMovies = moviesArr
                
                dispatch_async(dispatch_get_main_queue(), {
                    self.tableView.reloadSection(2)
                })
                
            } else {
                print("error loading related movies")
            }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return sections.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        switch section {
        case 0: // Links
            return self.links.count
        case 1: // Cast
            return 1
        case 2:
            return 1
        default:
            return 0
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCellWithIdentifier(GlobalConstants.Identifiers.Link, forIndexPath: indexPath) as! LinkTableViewCell
            
            let link = links[indexPath.row]
            
            var (linkShort, linkLong, _) = GlobalConstants.Links.LinkTypes[5]
            
            for linkType in GlobalConstants.Links.LinkTypes {
                (linkShort, linkLong, _) = linkType
                if linkShort == link.type {
                    break
                }
            }
            
            cell.imageView?.image = UIImage(named: "\(linkShort)_color.png")
            cell.textLabel?.text = linkLong
            
            // Configure the cell...
            if link.link.characters.count > 0 {
                cell.imageView?.image = UIImage(named: "\(linkShort)_color.png")
//                cell.textLabel?.makeBold()
                cell.detailTextLabel?.textColor = UIColor.blackColor()
                cell.detailTextLabel?.attributedText = link.pricesString()
                cell.userInteractionEnabled = true
            } else {
                cell.imageView?.image = UIImage(named: "\(linkShort).png")
                cell.detailTextLabel?.text = "No link"
                cell.detailTextLabel?.backgroundColor = GlobalConstants.Colors.VeryLightGrayColor
                cell.textLabel?.backgroundColor = GlobalConstants.Colors.VeryLightGrayColor
                cell.detailTextLabel?.textColor = UIColor.lightGrayColor()
                cell.textLabel?.textColor = UIColor.lightGrayColor()
                cell.contentView.backgroundColor = GlobalConstants.Colors.VeryLightGrayColor
                cell.accessoryType = UITableViewCellAccessoryType.None
                cell.userInteractionEnabled = false
            }
            
            cell.detailTextLabel?.sizeToFit()
            
            return cell
        case 1:
            
            let cell = tableView.dequeueReusableCellWithIdentifier(GlobalConstants.Identifiers.CastCollection.Container, forIndexPath: indexPath) as! CastTableViewCell
            //cell.setCollectionViewDataSourceDelegate(dataSourceDelegate: self, index: indexPath.section)
            
            return cell
        
        case 2:
            
            let cell = tableView.dequeueReusableCellWithIdentifier(GlobalConstants.Identifiers.RelatedCollection.Container, forIndexPath: indexPath) as! RelatedTableViewCell
            //cell.setCollectionViewDataSourceDelegate(dataSourceDelegate: self, index: indexPath.section)
            
            return cell
            
        default:
            return UITableViewCell()
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return GlobalConstants.Links.CellHeight
        default:
            return 190
        }
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.sections[section]
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerLabel = UILabel(frame: CGRectMake(15, 15, self.tableView.frame.width, 20))
        headerLabel.textColor = GlobalConstants.Colors.DefaultColor
        headerLabel.font = UIFont.boldSystemFontOfSize(18)
        headerLabel.text = self.tableView(self.tableView, titleForHeaderInSection: section)
        
        let headerView = UIView(frame: CGRectMake(0, 0, self.tableView.frame.width, 40))
        headerView.addSubview(headerLabel)
        headerView.backgroundColor = UIColor.groupTableViewBackgroundColor()
        
        return headerView
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let link = links[indexPath.row]
        
        if link.link.characters.count > 0 {
            UIApplication.tryURL(link.app_link())
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
    }
    
    ///////////////////////////////
    // COLLECTION VIEW
    ///////////////////////////////
    
    // MARK: - Collection View Data Source
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.section {
        case 1:
            let collectionCell: CastTableViewCell = cell as! CastTableViewCell
            collectionCell.setCollectionViewDataSourceDelegate(dataSourceDelegate: self, index: indexPath.section)
            let index: NSInteger = collectionCell.collectionView.tag
            let value: AnyObject? = self.contentOffsetDictionary.valueForKey(index.description)
            let horizontalOffset: CGFloat = CGFloat(value != nil ? value!.floatValue : 0)
            collectionCell.collectionView.setContentOffset(CGPointMake(horizontalOffset, 0), animated: false)

        case 2:
            let collectionCell: RelatedTableViewCell = cell as! RelatedTableViewCell
            collectionCell.setCollectionViewDataSourceDelegate(dataSourceDelegate: self, index: indexPath.section)
            let index: NSInteger = collectionCell.collectionView.tag
            let value: AnyObject? = self.contentOffsetDictionary.valueForKey(index.description)
            let horizontalOffset: CGFloat = CGFloat(value != nil ? value!.floatValue : 0)
            collectionCell.collectionView.setContentOffset(CGPointMake(horizontalOffset, 0), animated: false)

        default:
            break
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
    
}

extension LinksTableViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView.tag {
        case 1:
            return self.cast.count
        case 2:
            return self.relatedMovies.count
        default:
            return 0
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        

        switch collectionView.tag {
        case 1:
            let cell: ActorCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(GlobalConstants.Identifiers.CastCollection.Cell, forIndexPath: indexPath) as! ActorCollectionViewCell
            
            let actor = self.cast[indexPath.row]
            cell.configure(forActor: actor)
            
            return cell
            
        case 2:
            let cell: RelatedCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(GlobalConstants.Identifiers.RelatedCollection.Cell, forIndexPath: indexPath) as! RelatedCollectionViewCell
            
            let movie = self.relatedMovies[indexPath.row]
            cell.configure(forMovie: movie)
                        
            return cell
            
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        switch collectionView.tag {
        case 1:
            // push to actor view controller
            let selectedActor = self.cast[indexPath.item]
            
            // Set up the detail view controller to show.
            let detailViewController = ActorViewController.forActor(selectedActor)
            
            collectionView.deselectItemAtIndexPath(indexPath, animated: false)
            
            self.navigationController?.pushViewController(detailViewController, animated: true)
            
        case 2:
            let selectedMovie = self.relatedMovies[indexPath.item]
            
            // Set up the detail view controller to show.
            let detailViewController = MovieViewController.forMovie(selectedMovie)
            
            // Note: Should not be necessary but current iOS 8.0 bug requires it.
            //collectionView.deselectRowAtIndexPath(collectionView.indexPathsForSelectedItems()!, animated: false)
            
            self.navigationController?.pushViewController(detailViewController, animated: true)
        default:
            break
        }
    }
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        if !scrollView.isKindOfClass(UICollectionView) {
            return
        }
        let horizontalOffset: CGFloat = scrollView.contentOffset.x
        let collectionView: UICollectionView = scrollView as! UICollectionView
        self.contentOffsetDictionary.setValue(horizontalOffset, forKey: collectionView.tag.description)
    }
    
}