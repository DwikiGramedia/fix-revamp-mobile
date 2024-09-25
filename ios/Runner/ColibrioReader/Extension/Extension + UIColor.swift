//
//  Extension  + UIColor.swift
//  SCOOP
//
//  Created by Maul on 15/09/22.
//

import UIKit
import SwiftUI

extension UIColor {
    @nonobjc class var neutral40: UIColor {
        return BaseColor.setRGB(rgbValue: 0xE2E2E2)
    }
    
    @nonobjc class var neutral60: UIColor {
        return BaseColor.setRGB(rgbValue: 0xA3A3A2)
    }
    
    @nonobjc class var neutral70: UIColor {
        return BaseColor.setRGB(rgbValue: 0x7D7C7B)
    }
    
    
    @nonobjc class var neutral90: UIColor {
        return BaseColor.setRGB(rgbValue: 0x4A4948)
    }
    
    @nonobjc class var neutral100: UIColor {
        return BaseColor.setRGB(rgbValue: 0x181615)
    }
    
    @nonobjc class var successHover: UIColor {
        return BaseColor.setRGB(rgbValue: 0x00A171)
    }
    
    @nonobjc class var bluePrimaryMain: UIColor {
        return BaseColor.setRGB(rgbValue: 0x0060AF)
    }
    
    @nonobjc class var surface: UIColor {
        return BaseColor.setRGB(rgbValue: 0xE6EEF7)
    }
    
    @nonobjc class var pattensBlue: UIColor {
        return BaseColor.setRGB(rgbValue: 0xCCDFEF)
    }
    
    @nonobjc class var palePink: UIColor {
        return UIColor(red: 250.0/255.0, green: 213.0/255.0, blue: 218.0/255.0, alpha: 1.0)
    }
    
    @nonobjc class var surfCrest: UIColor {
        return UIColor(red: 209.0/255.0, green: 227.0/255.0, blue: 204.0/255.0, alpha: 1.0)
    }
    
    @nonobjc class var calamansi: UIColor {
        return UIColor(red: 252.0/255.0, green: 244.0/255.0, blue: 163.0/255.0, alpha: 1.0)
    }
    
    @nonobjc class var forestGreen: UIColor {
        return UIColor(red: 44.0/255.0, green: 133.0/255.0, blue: 22.0/255.0, alpha: 1.0)
    }
    
    @nonobjc class var cardinal: UIColor {
        return UIColor(red: 187.0/255.0, green: 32.0/255.0, blue: 51.0/255.0, alpha: 1.0)
    }
    
    @nonobjc class var mustardYellow: UIColor {
        return UIColor(red: 227.0/255.0, green: 177.0/255.0, blue: 4.0/255.0, alpha: 1.0)
    }
    
    var toSUIColor: Color? {
        return Color(self)
    }
}

class BaseColor: UIColor {
    
    // To set color by hex RGB
    static func setRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            displayP3Red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0))
    }
}

extension Date {
    func toString(format: DateFormatString) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format.text
        formatter.locale = Locale.init(identifier: "en_GB")
        return formatter.string(from: self)
    }
}

enum DateFormatString {
    case date
    case dateShort
    case dateTimezoneShort
    case dateTimezone
    case historyTransaction
    case dateOnly
    case timeOnly
    case timeFull
    case yyyyMmDd
    
    var text: String {
        switch self {
        case .date: return "dd MMMM yyyy"
        case .dateShort: return "dd MMM yyyy"
        case .dateTimezoneShort: return "yyyy-MM-dd HH:mm:ss Z"
        case .dateTimezone: return "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        case .historyTransaction: return "yyyy-MM-dd HH:mm:ss"
        case .yyyyMmDd: return "yyyy-MM-dd"
        case .dateOnly: return "dd-MM-yyyy"
        case .timeOnly: return "HH:mm"
        case .timeFull: return "HH:mm:ss"
        }
    }
}
