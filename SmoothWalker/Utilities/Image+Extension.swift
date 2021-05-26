//
//  Image+Extension.swift
//  SmoothWalker
//
//  Created by sokolli on 5/26/21.
//  Copyright © 2021 Apple. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    class func image(from string: String) -> UIImage {
        if let image = UIImage(named: string) {
            return image.resize(to: CGSize(width: 24, height: 24))
        }
        
        return UIImage()
    }
    
    private func resize(to size: CGSize) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }
    }
}
