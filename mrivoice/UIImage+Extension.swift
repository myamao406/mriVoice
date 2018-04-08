//
//  UIImage+Extension.swift
//  mrivoice
//
//  Created by it_dev01(yamao) on 2018/03/26.
//  Copyright © 2018年 it_dev01(yamao). All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    func flipHorizontal() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        let imageRef = self.cgImage
        // Contextを開く
        let context: CGContext = UIGraphicsGetCurrentContext()!
        context.translateBy(x: size.width, y:size.height)
        context.scaleBy(x: -1.0, y: -1.0)
        context.draw(imageRef!, in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let flipHorizontalImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return flipHorizontalImage!
    }
    
    
}
