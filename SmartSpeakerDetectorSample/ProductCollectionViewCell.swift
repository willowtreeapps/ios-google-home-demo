//
//  ProductCollectionViewCell.swift
//  SmartSpeakerDetectorSample
//
//  Created by Luke Tomlinson on 4/18/18.
//  Copyright © 2018 Luke Tomlinson. All rights reserved.
//

import UIKit

class ProductCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var shadowView: UIView!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!

    func congifure(with product: Product) {
        self.imageView.image = product.image
        self.titleLabel.text = product.title
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 4.0
        shadowView.layer.shadowPath = UIBezierPath(rect: shadowView.frame).cgPath
        shadowView.layer.cornerRadius = 4.0
        imageView.layer.cornerRadius = 4.0
        shadowView.layer.shadowRadius = 16.0
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.layer.shadowOpacity = 0.08
        shadowView.layer.shadowOffset = CGSize(width: 0, height: 4.0)
    }
}
