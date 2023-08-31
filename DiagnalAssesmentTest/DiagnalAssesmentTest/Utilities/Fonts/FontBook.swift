//
//  FontBook.swift
//  DiagnalAssessmentTest
//
//  Created by Ahmed Abbas on 31/08/23.
//


import Foundation
import UIKit

// Font Size
enum FontSize: CGFloat
{
    case size8 = 8.0
    case size9 = 9.0
    case size10 = 10.0
    case size11 = 11.0
    case size12 = 12.0
    case size13 = 13.0
    case size14 = 14.0
    case size15 = 15.0
    case size16 = 16.0
    case size17 = 17.0
    case size18 = 18.0
    case size19 = 19.0
    case size20 = 20.0
    case size22 = 22.0
    case size25 = 25.0
}

enum FontBook: String {
    
    case Black            = "TitilliumWeb-Black"
    case Bold             = "TitilliumWeb-Bold"
    case BoldItalic       = "TitilliumWeb-BoldItalic"
    case ExtraLight       = "TitilliumWeb-ExtraLight"
    case ExtraLightItalic = "TitilliumWeb-ExtraLightItalic"
    case Italic           = "TitilliumWeb-Italic"
    case Light            = "TitilliumWeb-Light"
    case LightItalic      = "TitilliumWeb-LightItalic"
    case Regular          = "TitilliumWeb-Regular"
    case SemiBold         = "TitilliumWeb-SemiBold"
    case SemiBoldItalic   = "TitilliumWeb-SemiBoldItalic"
    
    func of(size: CGFloat) -> UIFont {
        return UIFont(name: self.rawValue, size: size) ?? UIFont.systemFont(ofSize: 17)
    }
    
    func staticFont(size: CGFloat) -> UIFont {
        return UIFont(name: self.rawValue, size: size) ?? UIFont()
    }
    
    func setlabelFont(labels: [UILabel], size: CGFloat, textColour: UIColor) {
        for label in labels{
            label.font = staticFont(size: size)
            label.textColor = textColour
        }
    }
}



