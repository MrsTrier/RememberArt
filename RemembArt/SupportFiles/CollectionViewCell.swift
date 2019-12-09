//
//  CollectionViewCell.swift
//  RemembArt
//
//  Created by Roman Cheremin on 08/12/2019.
//  Copyright © 2019 Daria Cheremina. All rights reserved.
//

import UIKit

class ISSMenuCollectionViewCell: UICollectionViewCell {
    
    let textLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    let picture: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    override var isHighlighted: Bool{
        didSet{
            backgroundColor = isHighlighted ? .white : .green
            textLabel.textColor = isHighlighted ? .black : .white
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let imageView: UIImageView = {
            let imgView = UIImageView(frame: CGRect(x: self.bounds.width - 50, y: self.bounds.height - 50, width: 30, height: 30))
            imgView.tag = 21
            imgView.image = UIImage(named: "tick")
            imgView.alpha = 0
            return imgView
        }()
        
        picture.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        contentView.addSubview(picture)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 5
    override func prepareForReuse() {
        picture.image = nil;
    }
    
    // 6
    override func layoutSubviews() {
        super.layoutSubviews()
        picture.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
    }
}
