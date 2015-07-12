//
//  CollectionTableViewCell.swift
//  Movies
//
//  Created by Vincent Bello on 7/3/15.
//  Copyright (c) 2015 Vincent Bello. All rights reserved.
//

import UIKit

class CollectionView: UICollectionView {
    
    var indexPath: NSIndexPath!
}


class CollectionTableViewCell: UITableViewCell {

    var collectionView: CollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let layout = UICollectionViewFlowLayout()
        //layout.sectionInset = UIEdgeInsetsMake(0, 5, 3, 5)
        layout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10)
        layout.itemSize = CGSizeMake(90, 175)
        layout.scrollDirection = UICollectionViewScrollDirection.Horizontal
        layout.minimumInteritemSpacing = 15.0
        self.collectionView = CollectionView(frame: CGRectZero, collectionViewLayout: layout)
        self.collectionView.backgroundColor = UIColor.whiteColor()
        self.collectionView.showsHorizontalScrollIndicator = true
        self.contentView.addSubview(self.collectionView)
//        self.layoutMargins = UIEdgeInsetsMake(0, 0, 0, 0)
//        println(self.layoutMargins)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let frame = self.contentView.bounds
        self.collectionView.frame = frame
//        self.collectionView.frame = CGRectMake(0, 0.5, frame.size.width, frame.size.height - 1)
    }
    
    func setCollectionViewDataSourceDelegate(dataSourceDelegate delegate: protocol<UICollectionViewDelegate,UICollectionViewDataSource>, index: NSInteger) {
        self.collectionView.dataSource = delegate
        self.collectionView.delegate = delegate
        self.collectionView.tag = index
        self.collectionView.reloadData()
    }
    
    func setCollectionViewDataSourceDelegate(dataSourceDelegate delegate: protocol<UICollectionViewDelegate,UICollectionViewDataSource>, indexPath: NSIndexPath) {
        self.collectionView.dataSource = delegate
        self.collectionView.delegate = delegate
        self.collectionView.indexPath = indexPath
        self.collectionView.tag = indexPath.section
        self.collectionView.reloadData()
    }

}



class CollectionViewCell: UICollectionViewCell {

    private(set) var imageView : UIImageView?
    private(set) var nameLabel : UILabel?
    private(set) var aboutLabel : UILabel?
    
    override var selected: Bool {
        didSet {
            if self.selected {
                self.backgroundColor = GlobalConstants.Colors.DefaultColor
                self.nameLabel?.textColor = UIColor.whiteColor()
                self.aboutLabel?.textColor = UIColor.whiteColor()
            } else {
                self.backgroundColor = UIColor.clearColor()
                self.nameLabel?.textColor = GlobalConstants.Colors.DefaultColor
                self.aboutLabel?.textColor = UIColor.blackColor()
            }
        }
    }
    
    func configureElements() {
                
        if self.imageView == nil {
            self.imageView = UIImageView(frame: CGRectMake(5, 5, 80, 120))
            self.imageView?.backgroundColor = UIColor.darkGrayColor()
            self.imageView?.contentMode = UIViewContentMode.ScaleAspectFill
            self.imageView?.clipsToBounds
            self.nameLabel = UILabel()
            self.aboutLabel = UILabel()
            
            self.nameLabel!.frame.origin = CGPointMake(0, 130)
            self.nameLabel!.numberOfLines = 2
            self.nameLabel!.font = UIFont.boldSystemFontOfSize(11.5)
            self.nameLabel!.textColor = GlobalConstants.Colors.DefaultColor
            self.nameLabel!.textAlignment = NSTextAlignment.Center
            
            self.aboutLabel!.font = UIFont.systemFontOfSize(10.5)
            self.aboutLabel!.textAlignment = NSTextAlignment.Center
            
            self.contentView.addSubview(self.imageView!)
            self.contentView.addSubview(self.nameLabel!)
            self.contentView.addSubview(self.aboutLabel!)
            
        }
    }
}



