//
//  ViewController.swift
//  GoogleHomeDemo
//
//  Created by Luke Tomlinson on 4/18/18.
//  Copyright © 2018 Luke Tomlinson. All rights reserved.
//

import UIKit

class ViewController: UIViewController, GoogleHomeDemoing {

    @IBOutlet var collectionView: UICollectionView!

    var googleHomeTimer: Timer? = nil
    let detector: GoogleHomeDetector = GoogleHomeDetector()

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        setNeedsStatusBarAppearanceUpdate()
        let font = UIFont(name: "Avenir", size: 22.0)!
        self.navigationController?.navigationBar.titleTextAttributes = [.font: font]
        self.navigationController?.navigationBar.tintColor = .white

    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        guard case .motionShake = motion else { return }

        LocalNotificationManager.shared.showGoogleHomeNotification()
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

