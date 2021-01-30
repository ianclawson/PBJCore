//
//  NetworkManager.swift
//  stars2apples
//
//  Created by Ian Clawson on 3/8/20.
//  Copyright © 2020 Ian Clawson Apps. All rights reserved.
//

import Foundation
//import Reachability
//
//public class NetworkManager: NSObject {
//    public static let shared = NetworkManager()
//    public let reachability = Reachability()!
//    
//    deinit {
//        Log.deinitialize.event(Log.Event.deinitialized(self))
//        stopNotifier()
//    }
//    
//    public func startNotifier() {
//        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(note:)), name: .reachabilityChanged, object: reachability)
//        do {
//            try reachability.startNotifier()
//        } catch{
//            print("could not start reachability notifier")
//        }
//    }
//    
//    public func stopNotifier() {
//        reachability.stopNotifier()
//        NotificationCenter.default.removeObserver(self, name: .reachabilityChanged, object: reachability)
//    }
//    
//    public func connection() -> Reachability.Connection {
//        return reachability.connection
//    }
//    
//    public func isReachable() -> Bool {
//        switch reachability.connection {
//        case .wifi:
//            return true
//        case .cellular:
//            return true
//        case .none:
//            return false
//        }
//    }
//}
//
//extension NetworkManager {
//    @objc func reachabilityChanged(note: Notification) {
//        
//        let reachability = note.object as! Reachability
//        
//        switch reachability.connection {
//        case .wifi:
//            Log.network.message("Reachable via WiFi")
//        case .cellular:
//            Log.network.message("Reachable via Cellular")
//        case .none:
//            Log.network.message("Network not reachable")
//        }
//        
//        NotificationCenter.default.post(.networkChanged)
//    }
//}
