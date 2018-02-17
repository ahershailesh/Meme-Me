//
//  Constants.swift
//  VirtualTourist
//
//  Created by Shailesh Aher on 1/28/18.
//  Copyright © 2018 Shailesh Aher. All rights reserved.
//

import UIKit

//MARK:- Constant values
class Constants: NSObject {
    
    //MARK: Block
    typealias CompletionBlock = ((Bool,Any?,Error?) -> Void)
    typealias VoidBlock = (() -> Void)
    
    //MARK:- Enums
    //MARK:-
    enum ErrorCode : String {
        //Login
        case LoginFailed = "Login failed"
        
        //Network
        case Network = "No network available"
        
        //Server
        case ServerNotFound = "Server not found"
        
        //Default
        case None = "unable to reach server"
    }
    
    enum Color : Int {
        case LAVENDER, SUNGLO, HONEY_FLOWER, SHERPA_BLUE, PICTON_BLUE, MADISON, FOUNTAIN_BLUE, JACKSONS_PURPLE, MEDIUM_TURQUOISE, SUMMER_GREEN, SALEM, BLACK, ORANGE, GREEN, WHITE, BLUE, CYNE, PURPLE, RED, CLEAR
        
        func getColor() -> UIColor {
            switch self {
            case .LAVENDER : return UIColor(hex: "947CB0")
            case .SUNGLO  : return UIColor(hex: "E26A6A")
            case .HONEY_FLOWER  : return   UIColor(hex: "674172")
            case .SHERPA_BLUE  : return   UIColor(hex: "013243")
            case .PICTON_BLUE  : return   UIColor(hex: "59ABE3")
            case .MADISON  : return   UIColor(hex: "2C3E50")
            case .FOUNTAIN_BLUE  : return   UIColor(hex: "5C97BF")
            case .JACKSONS_PURPLE  : return   UIColor(hex: "1F3A93")
            case .MEDIUM_TURQUOISE  : return   UIColor(hex: "4ECDC4")
            case .SUMMER_GREEN  : return   UIColor(hex: "91B496")
            case .SALEM  : return  UIColor(hex:  "1E824C")
            case .BLACK: return  UIColor.black
            case .BLUE: return  UIColor.blue
            case .PURPLE: return  UIColor.purple
            case .ORANGE: return  UIColor.orange
            case .GREEN:  return  UIColor.green
            case .WHITE:  return  UIColor.white
            case .CYNE:  return  UIColor.cyan
            case .RED:  return  UIColor.red
            case .CLEAR : return UIColor.clear
            }
        }
        
        static func getRandomColor() -> UIColor {
            let randomNumber = Int(arc4random() % 20)
            return Color(rawValue: randomNumber)!.getColor()
        }
        
        static func getAllColors() -> [UIColor] {
            var colors = [UIColor]()
            for index in 0...20 {
                if let color = Constants.Color(rawValue: index)?.getColor() {
                    colors.append(color)
                }
            }
            return colors
        }
    }
}

let appDelegate = UIApplication.shared.delegate as! AppDelegate

//MARK:- global function
func saveLog(_ content : Any) {
    print(content)
}

func mainThread(block : Constants.VoidBlock?) {
    if Thread.isMainThread {
        block?()
    } else {
        DispatchQueue.main.sync {
            block?()
        }
    }
}

func backgroundThread(block : Constants.VoidBlock?) {
    DispatchQueue.global(qos: .background).async {
        block?()
    }
}
