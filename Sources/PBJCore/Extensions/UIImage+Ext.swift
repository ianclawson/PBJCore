//
//  UIImage+Ext.swift
//  stars2apples
//
//  Created by Ian Clawson on 2/15/20.
//  Copyright © 2020 Ian Clawson Apps. All rights reserved.
//

#if !os(macOS)
import UIKit

//extension UIImage {
//
//    @available(iOS 13.0, *)
//    open class var actions: UIImage { get }
//
//    @available(iOS 13.0, *)
//    open class var add: UIImage { get }
//
//    @available(iOS 13.0, *)
//    open class var remove: UIImage { get }
//
//    @available(iOS 13.0, *)
//    open class var checkmark: UIImage { get }
//
//    @available(iOS 13.0, *)
//    open class var strokedCheckmark: UIImage { get }
//}

extension UIImage
{
//    convenience init?(symbolNameIfAvailable name: String)
//    {
//        if #available(iOS 13, *)
//        {
//            self.init(systemName: name)
//        }
//        else
//        {
//            return nil
//        }
//    }
    class func symbolNameWithFallBack(name: String) -> UIImage? {
        if #available(iOS 13, *) {
            if let img = UIImage(systemName: name) {
                return img
            }
        }
        if let img = UIImage(named: name) {
            return img
        }
        return nil
    }
    
//    class func resizedImage(at url: URL, for size: CGSize) -> UIImage? {
//        guard let image = UIImage(contentsOfFile: url.path) else {
//            return nil
//        }
//
//        let renderer = UIGraphicsImageRenderer(size: size)
//        return renderer.image { (context) in
//            image.draw(in: CGRect(origin: .zero, size: size))
//        }
//    }
    
    func resizedImage(for size: CGSize) -> UIImage? {
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { (context) in
            self.draw(in: CGRect(origin: .zero, size: size))
        }
    }
    
    func jpegData() -> Data? {
        return self.jpegData(compressionQuality: Constants.JPG_COMPRESSION_QUALITY)
    }
    
    func gifData() -> Data? {
        if let gifData = try? AnimatedGIFImageSerialization.animatedGIFData(with: self) {
            return gifData
        }
        return nil
    }
    
    func asData(type: ImageType) -> Data? {
        switch type {
        case .jpeg:
            return self.jpegData()
        case .png:
            return self.pngData()
        case .gif:
            return self.gifData()
        }
    }
}

extension UIImage {
    func convertToBase64EncodedString() -> String? {
        if let imageData = self.pngData() {
            return imageData.base64EncodedString()
        }
        return nil
    }
    
    func isEqualToImage(image: UIImage) -> Bool {
        let data1: NSData = self.pngData()! as NSData
        let data2: NSData = image.pngData()! as NSData
        return data1.isEqual(data2)
    }
    
    func isEqualToImageData(imageData: NSData) -> Bool {
        let selfData: NSData = self.pngData()! as NSData
        return selfData.isEqual(imageData)
    }
    
    func fixOrientation() -> UIImage {
        if (self.imageOrientation == .up) {
            return self
        }
        
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
        self.draw(in: rect)
        
        let normalizedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return normalizedImage
    }
    
//    func cropToSquare(length: CGFloat?) -> UIImage {
//
//        let refWidth = CGFloat((self.cgImage!.width))
//        let refHeight = CGFloat((self.cgImage!.height))
//        let cropSize = length ?? refWidth > refHeight ? refHeight : refWidth
//
//        let x = (refWidth - cropSize) / 2.0
//        let y = (refHeight - cropSize) / 2.0
//
//        let cropRect = CGRect(x: x, y: y, width: cropSize, height: cropSize)
//        let imageRef = self.cgImage?.cropping(to: cropRect)
//        let cropped = UIImage(cgImage: imageRef!, scale: 0.0, orientation: self.imageOrientation)
//
//        return cropped
//    }
    
    func RBSquareImageTo(size: CGSize) -> UIImage? {
        return self.RBSquareImage()?.RBResizeImage(targetSize: size)
    }
    
    func RBSquareImage() -> UIImage? {
        let originalWidth  = self.size.width
        let originalHeight = self.size.height
        
        var edge: CGFloat
        if originalWidth > originalHeight {
            edge = originalHeight
        } else {
            edge = originalWidth
        }
        
        let posX = (originalWidth  - edge) / 2.0
        let posY = (originalHeight - edge) / 2.0
        
        let cropSquare = CGRect(x: posX, y: posY, width: edge, height: edge)
        
        let imageRef = self.cgImage?.cropping(to: cropSquare)
        
        return UIImage(cgImage: imageRef!, scale: UIScreen.main.scale, orientation: self.imageOrientation)
    }
    
    func RBResizeImage(targetSize: CGSize) -> UIImage {
        let size = self.size
        
        let widthRatio  = targetSize.width  / self.size.width
        let heightRatio = targetSize.height / self.size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, UIScreen.main.scale)
        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    func addImagePadding(x: CGFloat, y: CGFloat) -> UIImage? {
        let width: CGFloat = size.width + x
        let height: CGFloat = size.height + y
        UIGraphicsBeginImageContextWithOptions(CGSize(width: width, height: height), false, 0)
        let origin: CGPoint = CGPoint(x: (width - size.width) / 2, y: (height - size.height) / 2)
        draw(at: origin)
        let imageWithPadding = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return imageWithPadding
    }
    
    func addShadow(blurSize: CGFloat = 16.0) -> UIImage {
        
        let shadowColor = UIColor(white:0.0, alpha:0.8).cgColor
        
        let context = CGContext(
            data: nil,
            width: Int(self.size.width + blurSize*2),
            height: Int(self.size.height + blurSize*2),
            bitsPerComponent: self.cgImage!.bitsPerComponent,
            bytesPerRow: 0,
            space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
        )!
        
        context.setShadow(
            offset: CGSize.zero,
            blur: blurSize,
            color: shadowColor
        )
        
        context.draw(
            self.cgImage!,
            in: CGRect(x: blurSize, y: blurSize, width: self.size.width, height: self.size.height),
            byTiling: false
        )
        
        return UIImage(cgImage: context.makeImage()!)
    }
    
    public convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
}

#endif
