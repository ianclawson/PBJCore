//
//  FileHelper.swift
//  PBJCore
//
//  Created by Ian Clawson on 12/6/20.
//  Copyright © 2020 Ian Clawson Apps. All rights reserved.
//

import Foundation

struct FileHelper {
    @discardableResult static func addSkipBackupAttribute(url: URL) throws -> Bool {
        var fileUrl = url
        do {
            if FileManager.default.fileExists(atPath: fileUrl.path) {
                var resourceValues = URLResourceValues()
                resourceValues.isExcludedFromBackup = true
                try fileUrl.setResourceValues(resourceValues)
            }
            return true
        } catch {
            print("failed setting isExcludedFromBackup \(error)")
            return false
        }
    }
    
    @discardableResult static func removeSkipBackupAttribute(url: URL) throws -> Bool {
        var fileUrl = url
        do {
            if FileManager.default.fileExists(atPath: fileUrl.path) {
                var resourceValues = URLResourceValues()
                resourceValues.isExcludedFromBackup = false
                try fileUrl.setResourceValues(resourceValues)
            }
            return true
        } catch {
            print("failed removing isExcludedFromBackup \(error)")
            return false
        }
    }
}
