//
//  UIImageView+AssyncLoad.swift
//  Random People
//
//  Created by Maxim Lanskoy on 10.10.2018.
//  Copyright © 2018 Lanskoy. All rights reserved.
//

import UIKit

extension UIImageView {
    func loadImageWith(url: URL) {
        DispatchQueue.global().async() { () -> Void in
            if let data = NSData(contentsOf: url) {
                if let img = UIImage(data: data as Data) {
                    DispatchQueue.main.async(execute: {
                        self.image = img
                    })
                }
            }
        }
    }
}

