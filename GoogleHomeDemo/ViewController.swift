//
//  ViewController.swift
//  SmartSpeakerDetectorSample
//
//  Created by Luke Tomlinson on 4/18/18.
//  Copyright © 2018 Luke Tomlinson. All rights reserved.
//

import UIKit
import UserNotifications

class LightNavigationController: UINavigationController {

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

class ViewController: UIViewController, SmartSpeakerDetectorDemoing {

    @IBOutlet var collectionView: UICollectionView!

    var googleHomeTimer: Timer? = nil
    let detector: SmartSpeakerDetector = SmartSpeakerDetector()

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        let font = UIFont(name: "Karla-Bold", size: 22.0)!
        self.navigationController?.navigationBar.titleTextAttributes = [.font: font, .foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.tintColor = .white
        NotificationCenter.default.addObserver(self, selector: #selector(self.didBecomeActive), name: .UIApplicationDidBecomeActive, object: nil)

    }

    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        guard case .motionShake = motion else { return }

        LocalNotificationManager.shared.showGoogleHomeNotification()
    }

    @objc func didBecomeActive(_ notification: Notification) {
        LocalNotificationManager.shared.requestPermissions { _, _ in
            self.startPollingForGoogleHome()
        }
    }

}

extension UIViewController: UICollectionViewDataSource {

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCell", for: indexPath) as! ProductCollectionViewCell
        let product = products[indexPath.item]
        cell.congifure(with: product)

        return cell
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
}

