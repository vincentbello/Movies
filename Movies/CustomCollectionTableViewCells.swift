//
//  CastTableViewCell.swift
//  Movies
//
//  Created by Vincent Bello on 6/30/15.
//  Copyright (c) 2015 Vincent Bello. All rights reserved.
//

import UIKit

class CastTableViewCell: CollectionTableViewCell {

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
        self.collectionView.registerClass(ActorCollectionViewCell.self, forCellWithReuseIdentifier: GlobalConstants.Identifiers.CastCollection.Cell)

    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

class RelatedTableViewCell: CollectionTableViewCell {
    
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
        
        self.collectionView.registerClass(RelatedCollectionViewCell.self, forCellWithReuseIdentifier: GlobalConstants.Identifiers.RelatedCollection.Cell)
        
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
