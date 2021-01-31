//
//  UIImageView+Ext.swift
//  
//
//  Created by Ian Clawson on 1/30/21.
//

#if !os(macOS)
import UIKit

extension UIImageView {
    func setImageColor(color: UIColor) {
        let templateImage = self.image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        self.image = templateImage
        self.tintColor = color
    }
    
    
    func getNewHeightUsing(heightPercentage: CGFloat? = nil, widthPercentage: CGFloat? = nil) -> CGSize? {
        let hp : CGFloat? = heightPercentage > 0 ? heightPercentage : nil
        let wp : CGFloat? = widthPercentage > 0 ? widthPercentage : nil
        
        if let image = image {
            let screenHeight = UIScreen.main.bounds.height
            let screenWidth = UIScreen.main.bounds.width
            let ratio = image.size.width / image.size.height
            if let hp = hp {
                // if there's been a specified height percentage, use it and caculate new height and width
                //   r = w/h
                // h*r = w
                let newHeight = screenHeight * hp
                return CGSize(width: newHeight*ratio, height: newHeight)
            } else if let wp = wp {
                // if there's been a specified width percentage, use it and caculate new height and width
                //   r = w/h
                // h*r = w
                //   h = w/r
                let newWidth = screenWidth * wp
                return CGSize(width: newWidth, height: newWidth/ratio)
            } else {
                // resize imageview to be smaller if it exceeds bounds of screen
                if self.bounds.width > screenWidth ||
                    self.bounds.height > screenHeight {
                    let ratio = image.size.width / image.size.height
                    if screenWidth < UIScreen.main.bounds.height {
                        let newHeight = screenWidth / ratio
                        return CGSize(width: screenWidth, height: newHeight)
                    } else {
                        let newWidth = screenHeight * ratio
                        return CGSize(width: newWidth, height: screenHeight)
                    }
                } // end if image exceeds bounds of screen
            } // end else
        } // end if image
        return nil
    }
    
}
#endif
