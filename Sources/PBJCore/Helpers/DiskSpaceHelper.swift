//
//  DiskSpaceHelper.swift
//  PBJCore
//
//  Created by Ian Clawson on 2/9/20.
//  Copyright © 2020 Ian Clawson Apps. All rights reserved.
//


import Foundation

#if !os(macOS)
import UIKit

public class DiskSpaceHelper {
    
    public class func format(_ bytes: Int64, in units: ByteCountFormatter.Units = .useMB) -> String {
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = units
        formatter.countStyle = ByteCountFormatter.CountStyle.decimal
        formatter.includesUnit = false
        return formatter.string(fromByteCount: bytes) as String
    }

    //MARK: Get String Value
    public class var totalDiskSpace: String {
        get {
            return ByteCountFormatter.string(fromByteCount: totalDiskSpaceInBytes, countStyle: ByteCountFormatter.CountStyle.binary)
        }
    }

    public class var freeDiskSpace: String {
        get {
            return ByteCountFormatter.string(fromByteCount: freeDiskSpaceInBytes, countStyle: ByteCountFormatter.CountStyle.binary)
        }
    }

    public class var usedDiskSpace: String {
        get {
            return ByteCountFormatter.string(fromByteCount: usedDiskSpaceInBytes, countStyle: ByteCountFormatter.CountStyle.binary)
        }
    }


    // MARK: Get raw value
    public class var totalDiskSpaceInBytes: Int64 {
        get {
            do {
                let systemAttributes = try FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory() as String)
                let space = (systemAttributes[FileAttributeKey.systemSize] as? NSNumber)?.int64Value
                return space!
            } catch {
                return 0
            }
        }
    }

    public class var freeDiskSpaceInBytes: Int64 {
        get {
            do {
                let systemAttributes = try FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory() as String)
                let freeSpace = (systemAttributes[FileAttributeKey.systemFreeSize] as? NSNumber)?.int64Value
                return freeSpace!
            } catch {
                return 0
            }
        }
    }

    public class var usedDiskSpaceInBytes: Int64 {
        get {
            let usedSpace = totalDiskSpaceInBytes - freeDiskSpaceInBytes
            return usedSpace
        }
    }

}

public extension DiskSpaceHelper {
    class func sizeDescText(for sizeInBytes: NSNumber) -> String {
        let roundedSize = Int64(truncating: sizeInBytes)
        if roundedSize >= 1_000_000_000_000 {
            let sizeInMb = DiskSpaceHelper.format(Int64(truncating: sizeInBytes), in: .useTB)
            return "\(sizeInMb)TB"
        }
        if roundedSize >= 1_000_000_000 {
            let sizeInMb = DiskSpaceHelper.format(Int64(truncating: sizeInBytes), in: .useGB)
            return "\(sizeInMb)GB"
        }
        if roundedSize >= 1_000_000 {
            let sizeInMb = DiskSpaceHelper.format(Int64(truncating: sizeInBytes), in: .useMB)
            return "\(sizeInMb)MB"
        }
        let sizeInMb = DiskSpaceHelper.format(Int64(truncating: sizeInBytes), in: .useKB)
        return "\(sizeInMb)KB"
    }
}
#endif
