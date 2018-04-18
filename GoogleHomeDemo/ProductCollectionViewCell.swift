//
//  ProductCollectionViewCell.swift
//  GoogleHomeDemo
//
//  Created by Luke Tomlinson on 4/18/18.
//  Copyright © 2018 Luke Tomlinson. All rights reserved.
//

import UIKit

class ProductCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!

    func congifure(with product: Product) {
        self.imageView.image = product.image
        self.titleLabel.text = product.title
        self.titleLabel.font = UIFont(name: "Avenir", size: 16.0)!
    }
}
