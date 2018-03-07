//
//  ImageViewCollectionViewCell.swift
//  FindIt
//
//  Created by Shailesh Aher on 3/5/18.
//  Copyright © 2018 Shailesh Aher. All rights reserved.
//

import UIKit

class ImageViewCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.backgroundColor = UIColor.white
    }

    var model : MemeModel? {
        didSet {
            imageView.image = model?.memedImage
        }
    }
}
