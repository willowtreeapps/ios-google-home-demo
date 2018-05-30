//
//  SmartSpeakerDetector.swift
//  SmartSpeakerDetectorSample
//
//  Created by Greg Niemann on 4/5/18.
//  Copyright © 2018 Willowtree Apps. All rights reserved.
//

import Foundation

private extension String {
    static let googleService = "_googlecast._tcp."
    static let localDomain = "local."
}

class SmartSpeakerDetector: NSObject {
    private let serviceBrowser = NetServiceBrowser()
    private var castableDevices: [NetService] = []
    private var onDetect: ((Bool) -> Void)?
    private weak var timeoutTimer: Timer?
    
    func detectGoogleHome(_ completion: @escaping (Bool) -> Void) {
        onDetect = completion
        serviceBrowser.delegate = self
        serviceBrowser.searchForServices(ofType: .googleService, inDomain: .localDomain)
        
        timeoutTimer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: false) { [weak self] _ in
            self?.noHomeDetected()
        }
    }
    
    func stop(success: Bool) {
        serviceBrowser.stop()
        timeoutTimer?.invalidate()
        castableDevices = []
        onDetect?(success)
    }
    
    private func homeDetected() {
        print("Found a Google Home device")
        stop(success: true)
        
    }
    
    private func noHomeDetected() {
        print("No home detected")
        stop(success: false)
    }
}

extension SmartSpeakerDetector: NetServiceBrowserDelegate {
    func netServiceBrowser(_ browser: NetServiceBrowser, didFind service: NetService, moreComing: Bool) {
        print("Found service \(service.name)")
        castableDevices.append(service)
        service.delegate = self
        service.resolve(withTimeout: 5.0)
    }
    
    func netServiceBrowser(_ browser: NetServiceBrowser, didNotSearch errorDict: [String : NSNumber]) {
        print("Some type of error happened.")
        print(errorDict)
        onDetect?(false)
    }
}

extension SmartSpeakerDetector: NetServiceDelegate {
    func netServiceDidResolveAddress(_ sender: NetService) {
        print("Resolved")
        if let txtRecord = sender.txtRecordData(), let record = String(data: txtRecord, encoding: .ascii), record.contains("Google Home") {
               homeDetected()
        }
        
        castableDevices = castableDevices.filter { $0 !== sender }
    }
    
    func netService(_ sender: NetService, didNotResolve errorDict: [String : NSNumber]) {
        print("Did not resolve")
        castableDevices = castableDevices.filter { $0 !== sender }
    }
}
