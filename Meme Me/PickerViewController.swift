//
//  PickerViewController.swift
//  Meme Me
//
//  Created by Shailesh Aher on 2/11/18.
//  Copyright © 2018 Shailesh Aher. All rights reserved.
//

import UIKit

class PickerViewController: UIViewController {
    
    enum Section : Int {
        case first, second, third, forth
    }

    @IBOutlet weak var pickerView: UIPickerView!
    let pickerDataHandler = PickerViewDataHandler()
    
    let defaultWidth : CGFloat = 40
    
    var fontName : String
    var fontSize : Int
    var foregroundColor : UIColor
    var backgroundColor : UIColor
    
    var callBack : (() -> Void)?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        fontName = pickerDataHandler.getDefaultFont()
        fontSize = pickerDataHandler.getFontSize()
        foregroundColor = pickerDataHandler.getForegroundColor()
        backgroundColor = pickerDataHandler.getBackgroundColor()
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.dataSource = self
        pickerView.delegate = self
        pickerView.backgroundColor = UIColor.clear
        setupDefaults()
    }

    func getColorView(color: UIColor) -> UIView {
        let widthHeight : CGFloat = 24
        let view = UIView(frame: CGRect(origin: .zero, size: CGSize(width: widthHeight, height: widthHeight)))
        view.backgroundColor = color
        view.layer.cornerRadius = widthHeight/2
        return view
    }
    
    func getLabelView(text: String, component : Int = 0)  -> UIView {
        let height : CGFloat = 24
        var width : CGFloat = 48
        if component == 0 {
            width = getFontNameWidth()
        }
        
        let view = UIView(frame: CGRect(origin: .zero, size: CGSize(width: width, height: height)))
        let label = UILabel(frame: view.frame)
        label.text = text
        view.addSubview(label)
        return view
    }
    
    private func getFontNameWidth() -> CGFloat {
        return UIScreen.main.bounds.width - 3*defaultWidth - 16
    }
    
}

extension PickerViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return pickerDataHandler.dataSource.count
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerDataHandler.dataSource[component].count
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return component == 0 ? getFontNameWidth() : defaultWidth
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if let thisComponent = Section(rawValue: component) {
            switch thisComponent {
            case .first : fontName = (pickerDataHandler.dataSource[component][row] as? String) ?? "--"
            case .second : fontSize = (pickerDataHandler.dataSource[component][row] as? Int) ?? 12
            case .third : backgroundColor = (pickerDataHandler.dataSource[component][row] as? UIColor) ?? UIColor.black
            case .forth : foregroundColor = (pickerDataHandler.dataSource[component][row] as? UIColor) ?? UIColor.white
            }
        }
        callBack?()
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        if  let text = pickerDataHandler.dataSource[component][row] as? String {
            return getLabelView(text: text)
        } else if let number = pickerDataHandler.dataSource[component][row] as? Int {
            return getLabelView(text: "\(number)", component: component)
        } else if let color = pickerDataHandler.dataSource[component][row] as? UIColor {
            return getColorView(color: color)
        }
        return UIView()
    }
    
    private func setupDefaults() {
        pickerView.selectRow(pickerDataHandler.fontIndex, inComponent: Section.first.rawValue, animated: true)
        pickerView.selectRow(pickerDataHandler.sizeIndex, inComponent: Section.second.rawValue, animated: true)
        pickerView.selectRow(pickerDataHandler.backgroundColorIndex, inComponent: Section.third.rawValue, animated: true)
        pickerView.selectRow(pickerDataHandler.foregroundColorIndex, inComponent: Section.forth.rawValue, animated: true)
    }
}

