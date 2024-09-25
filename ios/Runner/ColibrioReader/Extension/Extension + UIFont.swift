//
//  Extension + UIFont.swift
//  SCOOP
//
//  Created by Maul on 14/09/22.
//

import UIKit
import SwiftUI

enum WeightSize {
    case regular
    case medium
    case semibold
    case bold
    
    var weight: UIFont.Weight {
        switch self {
        case .regular:
            return .regular
        case .medium:
            return .medium
        case .semibold:
            return .semibold
        case .bold:
            return .bold
        }
    }
}

enum FontStyle {
    case custom(_ size: CGFloat, weight: WeightSize)
    
    var size: CGFloat {
        switch self {
        case .custom(let size, _):
            return size
        }
    }
    
    var font: UIFont {
        switch self {
        case .custom(let size, let weight):
            return .setFont(.custom(size, weight: weight), weight: weight.weight)
        }
    }
}

extension UIFont {
    
    class func setFont(_ style: FontStyle, weight: Weight) -> UIFont {
        var fontName = "Nunito-Regular"
        switch weight {
        case .semibold: fontName = "Nunito-SemiBold"
        case .bold: fontName = "Nunito-Bold"
        case .medium: fontName = "Nunito-Medium"
        default: fontName = "Nunito-Regular"
        }
        return UIFont(name: fontName, size: style.size)!
    }
}

extension Font {

    public enum NunitoType: String {
        case Bold = "-Bold"
        case Regular = "-Regular"
        case Medium = "-Medium"
        case SemiBold = "-SemiBold"
    }

    static func Nunito(_ type: NunitoType = .Regular, size: CGFloat = UIFont.systemFontSize) -> Font {
        Font.custom("NunitoSans\(type.rawValue)", size: size)
    }
}
