//
//  Extension + UIDevice.swift
//  SCOOP
//
//  Created by Gramedia on 08/08/22.
//

import UIKit

var currentDevice = DeviceWidthSize.detectCurrentSize()

extension UIDevice {
    func isiPhoneXAbove()-> Bool{
        if UIScreen.maxHeight >= 812 {
            return true
        } else {
            return false
        }
    }
    
    static func maxWidth() -> CGFloat {
        return UIScreen.main.bounds.width
    }
    
    static func maxHeight() -> CGFloat {
        return UIScreen.main.bounds.height
    }
    
    static func deviceId() -> String {
        let deviceIdTemp = UIDevice.current.identifierForVendor!.uuidString
        return deviceIdTemp.replacingOccurrences(of: "-", with: "")
    }
}

//MARK: - Get IP Address Device
extension UIDevice {

    fileprivate static var hasNotch: Bool {
        if #available(iOS 11.0, tvOS 11.0, *) {
            return UIApplication.shared.delegate?.window??.safeAreaInsets.top ?? 0 > 20
        }
        return false
    }

    func ipAddress() -> String? {
        var address: String?
        var ifaddr: UnsafeMutablePointer<ifaddrs>? = nil
        if getifaddrs(&ifaddr) == 0 {
            var ptr = ifaddr
            while ptr != nil {
                defer { ptr = ptr?.pointee.ifa_next }
                
                guard let interface = ptr?.pointee else { return "" }
                let addrFamily = interface.ifa_addr.pointee.sa_family
                if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {
                    
                    // wifi = ["en0"]
                    // wired = ["en2", "en3", "en4"]
                    // cellular = ["pdp_ip0","pdp_ip1","pdp_ip2","pdp_ip3"]
                    
                    let name: String = String(cString: (interface.ifa_name))
                    if  name == "en0" || name == "en2" || name == "en3" || name == "en4" || name == "pdp_ip0" || name == "pdp_ip1" || name == "pdp_ip2" || name == "pdp_ip3" {
                        var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                        getnameinfo(interface.ifa_addr, socklen_t((interface.ifa_addr.pointee.sa_len)), &hostname, socklen_t(hostname.count), nil, socklen_t(0), NI_NUMERICHOST)
                        address = String(cString: hostname)
                    }
                }
            }
            freeifaddrs(ifaddr)
        }
        return address ?? ""
    }
}

enum DeviceWidthSize {
    case under350
    case normal
    case ipad
    
    /// Detect of current type device
    static func detectCurrentSize() -> DeviceWidthSize {
        let widthDevice = UIDevice.maxWidth()
        guard widthDevice >= 350 else { return .under350 }
        return widthDevice < 744 ? .normal : .ipad
    }
    
    /// To set height of button base on device type
    var sizeOfButton: CGFloat {
        switch self {
        case .under350:
            return 40
        case .normal:
            return 42
        case .ipad:
            return 44
        }
    }
    
//    static var paddingTopHome: CGFloat {
//        let hasNotch = UIDevice.hasNotch
//        guard hasNotch else {
//            return Helper.getTopPadding() + 89
//        }
//
//        return Defaults.getBool(.stateFirstInstallHome) == true ?  Helper.getTopPadding() + 111 - 50 : Helper.getTopPadding() + 111
//    }
    
    //MARK: - Product List
    /// To set width of item size banner premium package based on device type
    var packagePremiumCollection: CGFloat {
        switch self {
        case .under350:
            return 120
        case .normal:
            return 160
        case .ipad:
            return 200
        }
    }
    
    /// To set of card item when carousel type based on device
    var cardSizeOfHorizontal: CGSize {
        switch self {
        case .under350, .normal:
            return CGSize(width: 135, height: 316)
        case .ipad:
            return CGSize(width: 155, height: 316)
        }
    }
    
    /// To set of card item when product list type based on device
    var cardSizeOfVertical: CGSize {
        let widthSizeiPhone = (UIDevice.maxWidth() - 34)/2
        let widthSizeiPad = (UIDevice.maxWidth() - 40 - 48)/4
        switch self {
        case .under350, .normal:
            return CGSize(width: widthSizeiPhone, height: 350)
        case .ipad:
            return CGSize(width: widthSizeiPad, height: 350)
        }
    }
    
    var cardSizeOfVerticalOwnedItem: CGSize {
        let widthSizeiPhone = (UIDevice.maxWidth() - 34)/2
        let widthSizeiPad = (UIDevice.maxWidth() - 40 - 48)/4
        switch self {
        case .under350, .normal:
            return CGSize(width: widthSizeiPhone, height: 300)
        case .ipad:
            return CGSize(width: widthSizeiPad, height: 300)
        }
    }
    
    var cardSizeOfVerticalOwnedItemDownload: CGSize {
        let widthSizeiPhone = (UIDevice.maxWidth() - 34)/2
        let widthSizeiPad = (UIDevice.maxWidth() - 40 - 48)/4
        switch self {
        case .under350, .normal:
            return CGSize(width: widthSizeiPhone, height: 320)
        case .ipad:
            return CGSize(width: widthSizeiPad, height: 320)
        }
    }
    
    /// To set of card item on package details based on device
    var cardSizeOfPackageDetails: CGSize {
        let widthSizeiPhone = (UIDevice.maxWidth() - 34)/2
        let widthSizeiPad = (UIDevice.maxWidth() - 40 - 48)/4
        switch self {
        case .under350, .normal:
            return CGSize(width: widthSizeiPhone, height: 252)
        case .ipad:
            return CGSize(width: widthSizeiPad, height: 252)
        }
    }
    
    /// To set interim collection product list
    var interimCard: CGFloat {
        switch self {
        case .under350:
            return 8
        case .normal:
            return 10
        case .ipad:
            return 16
        }
    }
    
    /// To set line spacing collection product list
    var lineSpacingCard: CGFloat {
        switch self {
        case .under350, .normal:
            return 10
        case .ipad:
            return 16
        }
    }
    
    /// To set inset left right collection product list
    var insetHorizontalCollectionView: CGFloat {
        switch self {
        case .under350, .normal:
            return 12
        case .ipad:
            return 20
        }
    }
    
    //MARK: - Category List
    var interimCategory: CGFloat {
        switch self {
        case .under350, .normal:
            return 12
        case .ipad:
            return 15
        }
    }
    
    var cardSizeOfCategory: CGSize {
        switch self {
        case .under350, .normal:
            return CGSize(width: UIDevice.maxWidth() < 400 ? 90 : 120, height: 132)
        case .ipad:
            return CGSize(width: 120, height: 132)
        }
    }
}

extension UIDevice {
    static var isIPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }
    
    static var isIPhone: Bool {
        UIDevice.current.userInterfaceIdiom == .phone
    }
}
