//
//  ReviewPhotosCollectionViewCell.swift
//  FinalAppProject
//
//  Created by Paige Carey on 12/3/18.
//  Copyright © 2018 Paige Carey. All rights reserved.
//

import UIKit

class ReviewPhotosCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    var photo: Photo! {
        didSet {
            imageView.image = photo.image
        }
    }
    
}
