//
//  PreviewImageControllerViewController.swift
//  FindIt
//
//  Created by Shailesh Aher on 3/6/18.
//  Copyright © 2018 Shailesh Aher. All rights reserved.
//

import UIKit

class PreviewImageViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    
    var model : MemeModel? {
        didSet {
            imageView.image = model?.memedImage
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
