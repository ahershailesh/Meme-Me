//
//  MemeHandler.swift
//  Meme Me
//
//  Created by Shailesh Aher on 3/8/18.
//  Copyright © 2018 Shailesh Aher. All rights reserved.
//

import UIKit

class MemeHandler: NSObject {
    static let shared = MemeHandler()
    private override init() { }
    
    var memeList = [MemeModel]()
}
