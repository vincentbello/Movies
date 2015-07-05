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
        layout.sectionInset = UIEdgeInsetsMake(4, 5, 4, 5)
        layout.itemSize = CGSizeMake(100, 170)
        layout.scrollDirection = UICollectionViewScrollDirection.Horizontal
        self.collectionView = CollectionView(frame: CGRectZero, collectionViewLayout: layout)
        self.collectionView.backgroundColor = UIColor.whiteColor()
        self.collectionView.showsHorizontalScrollIndicator = true
        self.contentView.addSubview(self.collectionView)
        self.layoutMargins = UIEdgeInsetsMake(10, 0, 10, 0)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let frame = self.contentView.bounds
        self.collectionView.frame = CGRectMake(0, 0.5, frame.size.width, frame.size.height - 1)
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
    
    
    func configureElements() {
        
        if self.imageView == nil {
            self.imageView = UIImageView(frame: CGRectMake(17, 0, 80, 120))
            self.imageView?.contentMode = UIViewContentMode.ScaleAspectFill
            //self.nameLabel = UILabel(frame: CGRectMake(0, 110, 100, 15))
            self.nameLabel = UILabel()
            //self.aboutLabel = UILabel(frame: CGRectMake(0, 125, 100, 15))
            self.aboutLabel = UILabel()
            
            self.nameLabel!.frame.origin = CGPointMake(0, 125)
            self.nameLabel!.numberOfLines = 2
            self.nameLabel!.font = UIFont(name: GlobalConstants.Fonts.Main.Bold, size: 12.5)
            self.nameLabel!.textColor = GlobalConstants.Colors.DefaultColor
            self.nameLabel!.textAlignment = NSTextAlignment.Center
            
            self.aboutLabel!.font = UIFont(name: GlobalConstants.Fonts.Main.Regular, size: 11.0)
            //            self.aboutLabel!.textColor = UIColor.darkGrayColor()
            self.aboutLabel!.textAlignment = NSTextAlignment.Center
            
            self.contentView.addSubview(self.imageView!)
            self.contentView.addSubview(self.nameLabel!)
            self.contentView.addSubview(self.aboutLabel!)
            
        }
    }
}



