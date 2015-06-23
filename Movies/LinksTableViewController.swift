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
    
    var headerTitles = ["Links"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        println("before loading data: \(self.tableView.contentSize)")
        
        self.getLinks()
        

//        // Uncomment the following line to preserve selection between presentations
//        // self.clearsSelectionOnViewWillAppear = false
//        
//        let nib = UINib(nibName: GlobalConstants.Links.Cells.NibName, bundle: nil)
//
//        // Required if we want to use dequeueReusableCellWithIdentifier(_:)
//        tableView.registerNib(nib, forCellReuseIdentifier: GlobalConstants.Links.Cells.LinkCellIdentifier)
//        
//        self.tableView.separatorInset = UIEdgeInsetsZero

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
                    println(index)
                    var link = LinkObject(json: subJson)
                    linksArr.append(link)
                }
                self.links = linksArr
//                self.tableView.delegate = self.linksTableViewController
                
                dispatch_async(dispatch_get_main_queue(), {
//                    self.linksContainer.addSubview(self.linksTableViewController.tableView)
                    
                    self.tableView.reloadData()
                    println("tableview frame before: \(self.tableView.frame)")
                    self.tableView.frame = CGRectMake(0, 0, self.tableView.contentSize.width, self.tableView.frame.height)
                    println("tableview frame after: \(self.tableView.frame)")
                    println("reloaded data: \(self.links.count) links")
                    
                    println("after loading data: \(self.tableView.contentSize)")
                    println("after loading data frame: \(self.tableView.frame)")
                    
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
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        //return self.links.count
        return self.links.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(GlobalConstants.Links.Cells.LinkCellIdentifier, forIndexPath: indexPath) as! UITableViewCell

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
            cell.detailTextLabel?.text = link.pricesString()
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
            println("here")
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.headerTitles[section].uppercaseString
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerLabel = UILabel(frame: CGRectMake(15, 0, self.tableView.frame.width, 20))
        headerLabel.textColor = UIColor.lightGrayColor()
        headerLabel.font = UIFont.systemFontOfSize(14)
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
    
    
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
