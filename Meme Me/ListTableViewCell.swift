//
//  ListTableViewCell.swift
//  Meme Me
//
//  Created by Shailesh Aher on 3/8/18.
//  Copyright © 2018 Shailesh Aher. All rights reserved.
//

import UIKit

class ListTableViewCell: UITableViewCell {

    
    @IBOutlet weak var memedImage: UIImageView!
    @IBOutlet weak var subTitleText: UILabel!
    
    var model : MemeModel? {
        didSet {
            imageView?.image = model?.memedImage
            subTitleText?.text = model?.subTitles.joined(separator: ", ")
        }
    }
    
   
}
