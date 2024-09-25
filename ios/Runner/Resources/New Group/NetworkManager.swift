//
//  NetworkManager.swift
//  Runner
//
//  Created by Chondro Satrio Wibowo on 11/12/23.
//

import Foundation
import Alamofire

/// Network Manager to control and check internet connnection
class NetworkMonitorObserver {
    
    fileprivate static let networkManager = NetworkReachabilityManager(host: "www.apple.com")
    
    static var isConnected: Bool {
        return networkManager?.isReachable ?? false
    }
    
    static func isReachable(reachable: @escaping () -> Void, notReachable: @escaping () -> Void) {
        networkManager?.startListening { status in
            switch status {
            case .notReachable:
                notReachable()
            default:
                reachable()
            }
        }
    }
    
    static func removedObserverOfNetworkMonitor() {
        networkManager?.stopListening()
    }
}

