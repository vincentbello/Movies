//
//  CollectionTableViewCell.swift
//  Movies
//
//  Created by Vincent Bello on 6/26/15.
//  Copyright (c) 2015 Vincent Bello. All rights reserved.
//

import UIKit

class IndexedCollectionView: UICollectionView {
    
    var indexPath: NSIndexPath!
}




class CollectionTableViewCell: UITableViewCell {
    
    var collectionView: IndexedCollectionView!

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

        var layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsetsMake(4, 5, 4, 5)
        layout.minimumLineSpacing = 5
        layout.itemSize = CGSizeMake(100, 150)
        layout.scrollDirection = UICollectionViewScrollDirection.Horizontal
        self.collectionView = IndexedCollectionView(frame: CGRectZero, collectionViewLayout: layout)
        self.collectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: GlobalConstants.Identifiers.CollectionCell as String)
        self.collectionView.backgroundColor = UIColor.whiteColor()
        self.collectionView.showsHorizontalScrollIndicator = false
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
    
    func setCollectionViewDataSourceDelegate(dataSourceDelegate delegate: protocol<UICollectionViewDelegate, UICollectionViewDataSource>, index: NSInteger) {
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
