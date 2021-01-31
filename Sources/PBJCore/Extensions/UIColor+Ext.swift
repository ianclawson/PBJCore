//
//  UIColor+Ext.swift
//  
//
//  Created by Ian Clawson on 1/30/21.
//

#if !os(macOS)
import UIKit

extension UIColor {
    
    struct Compat {
        static var cellContent: UIColor {
            if #available(iOS 13, *) {
                return .s2aCellContentColor
            }
            return .white
        }
        static var label: UIColor {
            if #available(iOS 13.0, *) {
                return .label
            }
            return .black
        }
        static var grayGroupBackground: UIColor {
            if #available(iOS 13.0, *) {
                return .systemGroupedBackground
            }
            return .groupTableViewBackground
        }
        static var systemBackground: UIColor {
            if #available(iOS 13.0, *) {
                return .systemBackground
            }
            return .white
        }
    }
    
    static var pink: UIColor {
        return UIColor(red: 239/255,
                       green: 130/255,
                       blue: 176/255,
                       alpha: 1.0)
    }
    
    static var randomColor: UIColor {
        return UIColor(red: .random(in: 0...1),
                       green: .random(in: 0...1),
                       blue: .random(in: 0...1),
                       alpha: 1.0)
    }
    
    func inverseColor() -> UIColor {
        var alpha: CGFloat = 1.0
        
        var white: CGFloat = 0.0
        if self.getWhite(&white, alpha: &alpha) {
            return UIColor(white: 1.0 - white, alpha: alpha)
        }
        
        var hue: CGFloat = 0.0, saturation: CGFloat = 0.0, brightness: CGFloat = 0.0
        if self.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha) {
            return UIColor(hue: 1.0 - hue, saturation: 1.0 - saturation, brightness: 1.0 - brightness, alpha: alpha)
        }
        
        var red: CGFloat = 0.0, green: CGFloat = 0.0, blue: CGFloat = 0.0
        if self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
            return UIColor(red: 1.0 - red, green: 1.0 - green, blue: 1.0 - blue, alpha: alpha)
        }
        
        return self
    }
    
    static func == (l: UIColor, r: UIColor) -> Bool {
        var r1: CGFloat = 0
        var g1: CGFloat = 0
        var b1: CGFloat = 0
        var a1: CGFloat = 0
        l.getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
        var r2: CGFloat = 0
        var g2: CGFloat = 0
        var b2: CGFloat = 0
        var a2: CGFloat = 0
        r.getRed(&r2, green: &g2, blue: &b2, alpha: &a2)
        return r1 == r2 && g1 == g2 && b1 == b2 && a1 == a2
    }
}

func == (l: UIColor?, r: UIColor?) -> Bool {
    let l = l ?? .clear
    let r = r ?? .clear
    return l == r
}
#endif
