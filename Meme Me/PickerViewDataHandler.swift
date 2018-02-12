//
//  PickerViewDataHandler.swift
//  Meme Me
//
//  Created by Shailesh Aher on 2/11/18.
//  Copyright © 2018 Shailesh Aher. All rights reserved.
//

import UIKit

class PickerViewDataHandler: NSObject {
    
    enum PickerViewMode {
        case font, color, size
    }
    
    private var fontNames = [String]()
    private var backgroundColor = [UIColor]()
    
    private let sizes = [12, 13, 14, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30]
    
    private let forgroundColor : [UIColor]
    let dataSource : [[Any]]
    
    override init() {
        for familyName in UIFont.familyNames {
            let theseFontNames = UIFont.fontNames(forFamilyName: familyName)
            fontNames.append(contentsOf: theseFontNames)
        }
        
        for index in 0...20 {
            if let color = Constants.Color(rawValue: index)?.getColor() {
                backgroundColor.append(color)
            }
        }
        forgroundColor = backgroundColor
        dataSource = [fontNames, sizes, backgroundColor, forgroundColor]
        super.init()
    }
}
