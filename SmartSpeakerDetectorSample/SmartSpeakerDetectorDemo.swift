//
//  SmartSpeakerDetectorDemo.swift
//  SmartSpeakerDetectorSample
//
//  Created by Luke Tomlinson on 4/10/18.
//  Copyright © 2018 WillowTree. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    var highestPresentedViewController: UIViewController {
        return presentedViewController ?? self
    }
}

protocol SmartSpeakerDetectorDemoing: class {
    var pollInterval: TimeInterval { get }
    var detector: SmartSpeakerDetector { get }
    var googleHomeTimer: Timer? { get set }

    func onDetect(_ success: Bool)
    func startPollingForGoogleHome()
    func stopPollingForGoogleHome()
}

extension SmartSpeakerDetectorDemoing where Self: UIViewController {

    var pollInterval: TimeInterval { return 60.0 }

    func startPollingForGoogleHome() {
        resumePollingForGoogleHome()
        googleHomeTimer?.fire()
    }

    func resumePollingForGoogleHome() {
        googleHomeTimer = Timer.scheduledTimer(withTimeInterval: pollInterval, repeats: true) { [unowned self] blockTimer in
            self.detector.detectGoogleHome(self.onDetect)
        }
    }

    func stopPollingForGoogleHome() {
        googleHomeTimer?.invalidate()
    }

    func onDetect(_ success: Bool) {
        stopPollingForGoogleHome()
        alertResult(success)
    }

    func alertResult(_ success: Bool) {
        guard success else { return }

        LocalNotificationManager.shared.showGoogleHomeNotification()
    }

    func showGoogleHomeVC(completion: (() -> Void)? = nil) {
        let vc = SmartSpeakerDetectorOnboardingViewController.fromStoryboard()
        let presentAlert = { [weak self] () -> Void in self?.present(vc, animated: true, completion: completion)}

        if self.presentedViewController != nil {
            highestPresentedViewController.dismiss(animated: false, completion: presentAlert)
        } else {
            presentAlert()
        }
    }

    func createGoogleHomeAlert() -> UIAlertController {
        let alert = UIAlertController(title: "Google Home Found", message: "Hey looks like you have a google home", preferredStyle: .alert)
        let tryLaterAction = UIAlertAction(title: "Try again in \(pollInterval) seconds", style: .default, handler: { [weak self] _ in self?.resumePollingForGoogleHome()})
        let stopCheckingAction = UIAlertAction(title: "Don't check again", style: .default, handler: nil)

        alert.addAction(tryLaterAction)
        alert.addAction(stopCheckingAction)

        return alert
    }
}
