//
//  NetworkRechability.swift
//  Assignment_Calculator
//
//  Created by vinay kamra on 28/06/23.
//

import Foundation
import Network

enum NetworkConnectivityStatus {
    case unknown
    case connected
    case notConnected
}

protocol NetworkReachable: AnyObject {
    var connectivityStatus: NetworkConnectivityStatus { get }
    var connectivityStatusPublished: Published<NetworkConnectivityStatus> { get }
    var connectivityStatusPublisher: Published<NetworkConnectivityStatus>.Publisher { get }
    
    func monitorNetworkChange()
    func stopMonitoring()
}


final class NetworkReachability: NetworkReachable {
    
    static let shared = NetworkReachability()
    
    @Published var connectivityStatus: NetworkConnectivityStatus = .unknown
    var connectivityStatusPublished: Published<NetworkConnectivityStatus> { _connectivityStatus }
    var connectivityStatusPublisher: Published<NetworkConnectivityStatus>.Publisher { $connectivityStatus }
    
    let monitor: NWPathMonitor
    let queue = DispatchQueue(label: "Monitor")

    init() {
        monitor = NWPathMonitor()
        monitor.pathUpdateHandler = { path in
            DispatchQueue.main.async { [weak self] in
                self?.connectivityStatus = path.status == .satisfied ? .connected : .notConnected
            }
        }
    }
    
    func monitorNetworkChange() {
        monitor.start(queue: queue)
    }
    
    func stopMonitoring() {
        monitor.cancel()
    }
}
