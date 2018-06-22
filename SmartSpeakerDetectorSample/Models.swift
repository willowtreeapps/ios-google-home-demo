//
//  Models.swift
//  SmartSpeakerDetectorSample
//
//  Created by Luke Tomlinson on 4/18/18.
//  Copyright © 2018 Luke Tomlinson. All rights reserved.
//

import UIKit

let images: [UIImage] = [#imageLiteral(resourceName: "pineapple"), #imageLiteral(resourceName: "steak"), #imageLiteral(resourceName: "chicken"), #imageLiteral(resourceName: "Onions_O"), #imageLiteral(resourceName: "Broccoli_O"), #imageLiteral(resourceName: "Avocado_O"), #imageLiteral(resourceName: "strawberries")]
let titles = ["Pineapple", "Steak", "Chicken", "Onions","Broccoli","Avocado","Strawberries"]
let products = zip(titles, images).map(Product.init)

struct Product {
    let image: UIImage?
    let title: String

    init(title: String, image: UIImage? = nil) {
        self.title = title
        self.image = image
    }

    init(_ tuple: (String, UIImage)) {
        self.init(title: tuple.0, image: tuple.1)
    }
}
