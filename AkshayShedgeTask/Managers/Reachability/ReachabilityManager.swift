//
//  ReachabilityManager.swift
//  AkshayShedgeTask
//
//  Created by Akshay Shedge on 25/12/24.
//

import Network
import UIKit
import SystemConfiguration

class ReachabilityManager {
    static let shared = ReachabilityManager()

    private var reachability: SCNetworkReachability?
    private var isMonitoring = false

    var onReachable: (() -> Void)?
    var onUnreachable: (() -> Void)?

    private var debounceWorkItem: DispatchWorkItem?

    var isConnected: Bool {
        guard let reachability = reachability else { return false }

        var flags = SCNetworkReachabilityFlags()
        if SCNetworkReachabilityGetFlags(reachability, &flags) {
            return isReachable(with: flags)
        }

        return false
    }

    private init() {
        var zeroAddress = sockaddr_in(
            sin_len: UInt8(MemoryLayout<sockaddr_in>.size),
            sin_family: sa_family_t(AF_INET),
            sin_port: 0,
            sin_addr: in_addr(s_addr: inet_addr("0.0.0.0")),
            sin_zero: (0, 0, 0, 0, 0, 0, 0, 0)
        )

        reachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }
    }

    func startMonitoring() {
        guard let reachability = reachability, !isMonitoring else { return }
        isMonitoring = true

        var context = SCNetworkReachabilityContext(
            version: 0,
            info: UnsafeMutableRawPointer(Unmanaged.passUnretained(self).toOpaque()),
            retain: nil,
            release: nil,
            copyDescription: nil
        )

        SCNetworkReachabilitySetCallback(reachability, { (_, flags, info) in
            guard let info = info else { return }
            let instance = Unmanaged<ReachabilityManager>.fromOpaque(info).takeUnretainedValue()
            instance.handleReachabilityChange(flags)
        }, &context)

        SCNetworkReachabilitySetDispatchQueue(reachability, DispatchQueue.global(qos: .background))
    }

    func stopMonitoring() {
        guard let reachability = reachability, isMonitoring else { return }
        SCNetworkReachabilitySetDispatchQueue(reachability, nil)
        isMonitoring = false
    }

    private func handleReachabilityChange(_ flags: SCNetworkReachabilityFlags) {
        let isCurrentlyConnected = isReachable(with: flags)
        debounceWorkItem?.cancel()

        debounceWorkItem = DispatchWorkItem { [weak self] in
            DispatchQueue.main.async {
                if isCurrentlyConnected {
                    print("Internet is reachable")
                    self?.onReachable?()
                } else {
                    print("Internet is not reachable")
                    self?.onUnreachable?()
                }
            }
        }

        if let workItem = debounceWorkItem {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: workItem)
        }
    }

    private func isReachable(with flags: SCNetworkReachabilityFlags) -> Bool {
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        return isReachable && !needsConnection
    }
}
