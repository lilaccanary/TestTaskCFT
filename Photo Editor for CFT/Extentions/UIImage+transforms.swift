//
//  UIImage+transforms.swift
//  Photo Editor for CFT
//
//  Created by Алина Квашнина on 06.07.2021.
//

import Foundation
import UIKit

extension UIImage {
    
    func rotate(radians: Float) -> UIImage? {
        var newSize = CGRect(origin: CGPoint.zero, size: self.size).applying(CGAffineTransform(rotationAngle: CGFloat(radians))).size
        newSize.width = floor(newSize.width)
        newSize.height = floor(newSize.height)
        UIGraphicsBeginImageContextWithOptions(newSize, false, self.scale)
        if let context = UIGraphicsGetCurrentContext() {
            context.translateBy(x: newSize.width/2, y: newSize.height/2)
            context.rotate(by: CGFloat(radians))
            self.draw(in: CGRect(x: -self.size.width/2, y: -self.size.height/2, width: self.size.width, height: self.size.height))
            let newImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return newImage } else { return self }
    }
    func invert() -> UIImage {
        let filter = CIFilter(name: "CIPhotoEffectMono")
        let ciInput = CIImage(image: self)
        filter?.setValue(ciInput, forKey: "inputImage")
        let ciOutput = filter?.outputImage
        let ciContext = CIContext()
        if ciOutput != nil, ciOutput != nil {
            let cgImage = ciContext.createCGImage(ciOutput!, from: (ciOutput?.extent)!)
            return UIImage(cgImage: cgImage!) } else { return self }
    }
    
    func mirror() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        if let context = UIGraphicsGetCurrentContext() {
            context.translateBy(x: self.size.width/2, y: self.size.height/2)
            context.scaleBy(x: -1.0, y: 1.0)
            context.translateBy(x: -self.size.width/2, y: -self.size.height/2)
            self.draw(in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
            let newImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return newImage } else { return self }
    }
}

extension UIImage {
    func getCropRatioNot() -> CGFloat {
        let widthRatio = CGFloat(self.size.width / self.size.height)
        return widthRatio
    }
    
    func getCropRatio() -> CGFloat {
        let widthRatio = CGFloat(self.size.height / self.size.width)
        return widthRatio
    }
}
