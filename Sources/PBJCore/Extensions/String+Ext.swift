//
//  String+Ext.swift
//  stars2apples
//
//  Created by Ian Clawson on 3/4/20.
//  Copyright © 2020 Ian Clawson Apps. All rights reserved.
//

import Foundation
#if !os(macOS)
import UIKit

extension String {
    var titlecased: String {
        let lowercaseWords = ["a", "an", "the", "and", "but", "for", "or", "at", "by", "from", "to"]
        
        var string = self
        enumerateSubstrings(in: startIndex..<endIndex, options: .byWords) { (substring, substringRange, _, _) in
            if let word = substring {
                if lowercaseWords.contains(word.lowercased()) {
                    string.replaceSubrange(substringRange, with: word.localizedLowercase)
                } else {
                    string.replaceSubrange(substringRange, with: word.localizedCapitalized)
                }
            }
        }
        
        return string
    }
    
    func base64Encoded() -> String? {
        return data(using: .utf8)?.base64EncodedString()
    }
    func base64Decoded() -> String? {
        guard let data = Data(base64Encoded: self) else { return nil }
        return String(data: data, encoding: .utf8)
    }
    func convertFromBase64EncodedStringToData() -> Data? {
        let dataDecoded = Data(base64Encoded: self, options: .ignoreUnknownCharacters)
        if let data = dataDecoded {
            return data
        }
        return nil
    }
    func convertFromBase64EncodedStringToImage(isGif: Bool = false) -> UIImage? {
        let dataDecoded = Data(base64Encoded: self, options: .ignoreUnknownCharacters)
        if let data = dataDecoded {
            if isGif {
                if let image = UIImage.gif(data: data) {
                    return image
                }
            }
            if let image = UIImage(data: data) {
                return image
            }
        }
        return nil
    }
    
    var containsEmoji: Bool {
        for scalar in unicodeScalars {
            switch scalar.value {
            case 0x1F600...0x1F64F, // Emoticons
            0x1F300...0x1F5FF, // Misc Symbols and Pictographs
            0x1F680...0x1F6FF, // Transport and Map
            0x2600...0x26FF,   // Misc symbols
            0x2700...0x27BF,   // Dingbats
            0xFE00...0xFE0F:   // Variation Selectors
                return true
            default:
                continue
            }
        }
        return false
    }
    var containsWhitespace: Bool {
        return(self.rangeOfCharacter(from: .whitespacesAndNewlines) != nil)
    }
    var containsNonAlphabeticCharacters: Bool {
        let characterset = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ")
        if rangeOfCharacter(from: characterset.inverted) != nil {
            return true
        }
        return false
    }
    func containsCharactersIn(charSet: String = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789") -> Bool {
        let characterset = CharacterSet(charactersIn: charSet)
        if rangeOfCharacter(from: characterset.inverted) != nil {
            return true
        }
        return false
    }
    
    func removeSpecialChatacters() -> String {
        return components(separatedBy: CharacterSet.symbols).joined(separator: "").replacingOccurrences(of: "/", with: "").replacingOccurrences(of: "\\", with: "")
    }
    func removeWhitespaceFromBothEnds() -> String {
        return trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func fileNameWithoutExtension() -> String {
        return NSURL(fileURLWithPath: self).deletingPathExtension?.lastPathComponent ?? ""
    }
    func fileExtension() -> String {
        return NSURL(fileURLWithPath: self).pathExtension ?? ""
    }
}
#endif
