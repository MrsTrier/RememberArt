//
//  CollectionViewCell.swift
//  RemembArt
//
//  Created by Roman Cheremin on 08/12/2019.
//  Copyright © 2019 Daria Cheremina. All rights reserved.
//

import UIKit

class ISSMenuCollectionViewCell: UICollectionViewCell {
    
    var cellSelected = false
    
    let picture: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    let imageView: UIImageView = {
        let imgView = UIImageView()
        imgView.tag = 21
        imgView.image = UIImage(named: "check")
        imgView.alpha = 0
        return imgView
    }()
    
    var pictureData = Image(name: "", artist: "", description: "", url: nil, png: nil)
    override var isHighlighted: Bool{
        didSet{
            backgroundColor = isHighlighted ? .white : .green
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
//        let imageView: UIImageView = {
        imageView.frame = CGRect(x: self.bounds.width - 50, y: self.bounds.height - 50, width: 30, height: 30)
//            imgView.tag = 21
//            imgView.image = UIImage(named: "check")
//            imgView.alpha = 0
//            return imgView
//        }()
        
        picture.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        picture.addSubview(imageView)
        contentView.addSubview(picture)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 5
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    // 6
    override func layoutSubviews() {
        super.layoutSubviews()
        picture.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
    }
}
