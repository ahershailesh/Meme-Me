//
//  PickerViewDataHandler.swift
//  Meme Me
//
//  Created by Shailesh Aher on 2/11/18.
//  Copyright © 2018 Shailesh Aher. All rights reserved.
//

import UIKit

class PickerViewDataHandler: NSObject {
    
    let fontIndex = 56
    let sizeIndex = 7
    let backgroundColorIndex = 19
    let foregroundColorIndex = 14
    
    enum PickerViewMode {
        case font, color, size
    }
    
    var fontNames = [String]()
    var backgroundColor = [UIColor]()
    let sizes = [12, 13, 14, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30]
    let forgroundColor : [UIColor]
    let dataSource : [[Any]]
    
    override init() {
        for familyName in UIFont.familyNames {
            let theseFontNames = UIFont.fontNames(forFamilyName: familyName)
            fontNames.append(contentsOf: theseFontNames)
        }
        backgroundColor = Constants.Color.getAllColors()
        forgroundColor = Constants.Color.getAllColors()
        dataSource = [fontNames, sizes, backgroundColor, forgroundColor]
        super.init()
    }
    
    func getDefaultFont() -> String {
        return fontNames[fontIndex]
    }
    
    func getForegroundColor() -> UIColor {
        return forgroundColor[foregroundColorIndex]
    }
    
    func getBackgroundColor() -> UIColor {
        return backgroundColor[backgroundColorIndex]
    }
    
    func getFontSize() -> Int {
        return sizes[sizeIndex]
    }
}
