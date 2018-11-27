//
//  MyAlbumCollectionViewCell.swift
//  AppsFactoryTest
//
//  Created by suricat on 03.11.18.
//  Copyright © 2018 suricat. All rights reserved.
//

import UIKit
import Kingfisher

class MyAlbumCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var albumNameLabel: UILabel!
    

    @IBOutlet weak var albumImage: UIImageView!
    
    //var images : [Image]?
    
	func updateCell(with image: String, andFavorite: Bool) {
        let url = URL(string: image)
        albumImage.kf.setImage(with: url)
		if andFavorite {
			albumImage.alpha = 0.5
		}
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
