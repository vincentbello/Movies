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
    
    var sections = ["Links", "Cast"]
    
    
    
    var colorsArray: [UIColor] = [UIColor.blueColor(), UIColor.grayColor(), UIColor.greenColor(), UIColor.blueColor(), UIColor.redColor(), UIColor.yellowColor(), UIColor.orangeColor(), UIColor.brownColor()]
    
    var actorsArray: [Actor] = [Actor(id: 1, name: "Leo DiCaprio", about: "nayshes heavily"), Actor(id: 2, name: "George Lucas", about: "kasjdnvkajsdnv"), Actor(id: 3, name: "Brad Pitt", about: "Cyphs hardbody")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.getLinks()
        

//        // Uncomment the following line to preserve selection between presentations
//        // self.clearsSelectionOnViewWillAppear = false
//        
//        let nib = UINib(nibName: GlobalConstants.Links.Cells.NibName, bundle: nil)
//
//        // Required if we want to use dequeueReusableCellWithIdentifier(_:)
//        tableView.registerNib(nib, forCellReuseIdentifier: GlobalConstants.Identifiers.Link)
//        
        self.tableView.separatorInset = UIEdgeInsetsZero
        
        
        println("this runs first")
        self.tableView.registerClass(CollectionTableViewCell.self, forCellReuseIdentifier: GlobalConstants.Identifiers.CollectionContainer)
        
    }
    
//    override func loadView() {
//        self.tableView = UITableView()
//    }
    
    func getLinks() {
        
        let dataFetchLink = "http://api.readyto.watch/links.php?id=\(currentMovie.id)&key=\(GlobalConstants.APIKey)"
        
        RestAPIManager.sharedInstance.getPopularMovies(dataFetchLink) { json in
            
            if json != nil {
                let linksArray = json["links"]
                
                var linksArr = [LinkObject]()
                for (index: String, subJson: JSON) in linksArray {
                    var link = LinkObject(json: subJson)
                    linksArr.append(link)
                }
                self.links = linksArr
//                self.tableView.delegate = self.linksTableViewController
                
                dispatch_async(dispatch_get_main_queue(), {
//                    self.linksContainer.addSubview(self.linksTableViewController.tableView)
                    
                    self.tableView.reloadData()
                    //self.tableView.frame = CGRectMake(0, 0, self.tableView.contentSize.width, self.tableView.frame.height)
                    
                })
                
                let frame = self.tableView.superview?.frame
                
            } else {
                println("error loading links")
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
        default:
            return 0
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCellWithIdentifier(GlobalConstants.Identifiers.Link, forIndexPath: indexPath) as! LinkTableViewCell
            
            let link = links[indexPath.row]
            
            var (linkShort, linkLong, linkCaption) = GlobalConstants.Links.LinkTypes[5]
            
            for linkType in GlobalConstants.Links.LinkTypes {
                (linkShort, linkLong, linkCaption) = linkType
                if linkShort == link.type {
                    break
                }
            }
            
            cell.imageView?.image = UIImage(named: "\(linkShort)_color.png")
            cell.textLabel?.text = linkLong
            
            // Configure the cell...
            if count(link.link) > 0 {
                cell.imageView?.image = UIImage(named: "\(linkShort)_color.png")
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
            
            //let collectionCell: CollectionTableViewCell = cell as! CollectionTableViewCell
            //collectionCell.setCollectionViewDataSourceDelegate(dataSourceDelegate: self, index: indexPath.row)

            
            
            let cell = tableView.dequeueReusableCellWithIdentifier(GlobalConstants.Identifiers.CollectionContainer, forIndexPath: indexPath) as! CollectionTableViewCell
            cell.setCollectionViewDataSourceDelegate(dataSourceDelegate: self, index: indexPath.row)
            
            return cell
            
        default:
            let cell = tableView.dequeueReusableCellWithIdentifier(GlobalConstants.Identifiers.Link, forIndexPath: indexPath) as! LinkTableViewCell
            
            cell.textLabel?.text = "Naysh City, USA"
            
            return cell
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return GlobalConstants.Links.CellHeight
        default:
            return 150
        }
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 36
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.sections[section]
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerLabel = UILabel(frame: CGRectMake(15, 10, self.tableView.frame.width, 20))
        headerLabel.textColor = GlobalConstants.Colors.DefaultColor
        headerLabel.font = UIFont(name: GlobalConstants.Fonts.Main.Regular, size: 18)
        headerLabel.text = self.tableView(self.tableView, titleForHeaderInSection: section)
        
        let headerView = UIView()
        headerView.addSubview(headerLabel)
        headerView.backgroundColor = UIColor.groupTableViewBackgroundColor()
        
        return headerView
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let superview = self.tableView.superview!.frame.size
        
        let link = links[indexPath.row]

        if count(link.link) > 0 {
            let links = link.app_link()
            UIApplication.tryURL(link.app_link())
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
    }
    
    ///////////////////////////////
    // COLLECTION VIEW
    ///////////////////////////////
    
    // MARK: - Collection View Data Source
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 1 {
//            let collectionCell: CollectionTableViewCell = cell as! CollectionTableViewCell
//            collectionCell.setCollectionViewDataSourceDelegate(dataSourceDelegate: self, index: indexPath.row)
            //let index: NSInteger = collectionCell.collectionView.tag
//            let value: AnyObject? = self.contentOffsetDictionary.valueForKey(index.description)
//            let horizontalOffset: CGFloat = CGFloat(value != nil ? value!.floatValue : 0)
//            collectionCell.collectionView.setContentOffset(CGPointMake(horizontalOffset, 0), animated: false)
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
        println("this runs second")
        return self.actorsArray.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: UICollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(GlobalConstants.Identifiers.CollectionCell, forIndexPath: indexPath) as! UICollectionViewCell
        
        //cell.backgroundColor = self.colorsArray[indexPath.item]

        cell.layer.borderColor = UIColor.redColor().CGColor
        cell.layer.borderWidth = 2.0
        let actor = self.actorsArray[indexPath.item]
        
        let imageView = UIImageView(frame: CGRectMake(25, 10, 50, 100))
        let textLabel = UILabel(frame: CGRectMake(0, 110, 100, 15))
        let infoLabel = UILabel(frame: CGRectMake(0, 125, 100, 15))
        
        imageView.image = actor.image
        
        textLabel.text = actor.name
        textLabel.font = UIFont(name: GlobalConstants.Fonts.Main.Bold, size: 13.0)
        textLabel.textColor = GlobalConstants.Colors.DefaultColor
        
        infoLabel.text = actor.about
        infoLabel.font = UIFont(name: GlobalConstants.Fonts.Main.Regular, size: 11.5)
        infoLabel.textColor = UIColor.lightGrayColor()
        
        cell.addSubview(imageView)
        cell.addSubview(textLabel)
        cell.addSubview(infoLabel)
        
        
        return cell
    }
    
//    override func scrollViewDidScroll(scrollView: UIScrollView) {
//        if !scrollView.isKindOfClass(UICollectionView) {
//            return
//        }
//        let horizontalOffset: CGFloat = scrollView.contentOffset.x
//        let collectionView: UICollectionView = scrollView as! UICollectionView
//        self.contentOffsetDictionary.setValue(horizontalOffset, forKey: collectionView.tag.description)
//    }
    
    
    
    
}
