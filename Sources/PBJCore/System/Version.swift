//
//  Version.swift
//  PBJCore
//
//  Created by Ian Clawson on 12/27/20.
//  Copyright © 2020 Ian Clawson Apps. All rights reserved.
//

import Foundation

/// A version according to the semantic versioning specification.
///
/// A package version is a three period-separated integer, for example `1.0.0`. It must conform to the semantic versioning standard in order to ensure
/// that your package behaves in a predictable manner once developers update their
/// package dependency to a newer version. To achieve predictability, the semantic versioning specification proposes a set of rules and
/// requirements that dictate how version numbers are assigned and incremented. To learn more about the semantic versioning specification, visit
/// [semver.org](www.semver.org).
///
/// **The Major Version**
///
/// The first digit of a version, or  *major version*, signifies breaking changes to the API that require
/// updates to existing clients. For example, the semantic versioning specification
/// considers renaming an existing type, removing a method, or changing a method's signature
/// breaking changes. This also includes any backward-incompatible bug fixes or
/// behavioral changes of the existing API.
///
/// **The Minor Version**
///
/// Update the second digit of a version, or *minor version*, if you add functionality in a backward-compatible manner.
/// For example, the semantic versioning specification considers adding a new method
/// or type without changing any other API to be backward-compatible.
///
/// **The Patch Version**
///
/// Increase the third digit of a version, or *patch version*, if you are making a backward-compatible bug fix.
/// This allows clients to benefit from bugfixes to your package without incurring
/// any maintenance burden.
public struct Version: Comparable {
    
    /// The major version according to the semantic versioning standard.
    public let major: Int
    
    /// The minor version according to the semantic versioning standard.
    public let minor: Int
    
    /// The patch version according to the semantic versioning standard.
    public let patch: Int
    
    /// The pre-release identifier according to the semantic versioning standard, such as `-beta.1`.
    public let prereleaseIdentifiers: [String]
    
    /// The build metadata of this version according to the semantic versioning standard, such as a commit hash.
    public let buildMetadataIdentifiers: [String]
    
    private var isPrerelease: Bool {
        !self.prereleaseIdentifiers.isEmpty
    }
    
    /// Initializes and returns a newly allocated version struct
    /// for the provided components of a semantic version.
    ///
    /// - Parameters:
    ///     - major: The major version numner.
    ///     - minor: The minor version number.
    ///     - patch: The patch version number.
    ///     - prereleaseIdentifiers: The pre-release identifier.
    ///     - buildMetaDataIdentifiers: Build metadata that identifies a build.
    public init(_ major: Int, _ minor: Int, _ patch: Int, prereleaseIdentifiers: [String] = [], buildMetadataIdentifiers: [String] = []) {
        precondition(major >= 0 && minor >= 0 && patch >= 0, "Negative versioning is invalid.")
        self.major = major
        self.minor = minor
        self.patch = patch
        self.prereleaseIdentifiers = prereleaseIdentifiers
        self.buildMetadataIdentifiers = buildMetadataIdentifiers
    }
    
    public static func < (lhs: Self, rhs: Self) -> Bool {
        let lhsComparators = [lhs.major, lhs.minor, lhs.patch]
        let rhsComparators = [rhs.major, rhs.minor, rhs.patch]
        
        if lhsComparators != rhsComparators {
            return lhsComparators.lexicographicallyPrecedes(rhsComparators)
        }
        
        guard lhs.prereleaseIdentifiers.count > 0 else {
            return false // Non-prerelease lhs >= potentially prerelease rhs
        }
        
        guard rhs.prereleaseIdentifiers.count > 0 else {
            return true // Prerelease lhs < non-prerelease rhs
        }
        
        let zippedIdentifiers = zip(lhs.prereleaseIdentifiers, rhs.prereleaseIdentifiers)
        for (lhsPrereleaseIdentifier, rhsPrereleaseIdentifier) in zippedIdentifiers {
            if lhsPrereleaseIdentifier == rhsPrereleaseIdentifier {
                continue
            }
            
            let typedLhsIdentifier: Any = Int(lhsPrereleaseIdentifier) ?? lhsPrereleaseIdentifier
            let typedRhsIdentifier: Any = Int(rhsPrereleaseIdentifier) ?? rhsPrereleaseIdentifier
            
            switch (typedLhsIdentifier, typedRhsIdentifier) {
            case let (int1 as Int, int2 as Int): return int1 < int2
            case let (string1 as String, string2 as String): return string1 < string2
            case (is Int, is String): return true // Int prereleases < String prereleases
            case (is String, is Int): return false
            default:
                return false
            }
        }
        
        return lhs.prereleaseIdentifiers.count < rhs.prereleaseIdentifiers.count
    }
    
}

extension Version: ExpressibleByStringLiteral {
    
    /// Initializes and returns a newly allocated version struct for the provided string literal.
    ///
    /// - Parameters:
    ///     - version: A string literal to use for creating a new version object.
    public init(stringLiteral value: String) {
        guard let version = Version(value) else {
            self.init(0, 0, 0)
            return
        }
        
        self.init(version)
    }
    
    /// Initializes a version struct with the provided version.
    ///
    /// - Parameters:
    ///     - version: A version object to use for creating a new version struct.
    public init(_ version: Version) {
        major = version.major
        minor = version.minor
        patch = version.patch
        prereleaseIdentifiers = version.prereleaseIdentifiers
        buildMetadataIdentifiers = version.buildMetadataIdentifiers
    }
    
    /// Initializes and returns a newly allocated version struct for the provided version string.
    ///
    /// - Parameters:
    ///     - version: A version string to use for creating a new version object.
    public init?(_ versionString: String) {
        let prereleaseStartIndex = versionString.firstIndex(of: "-")
        let metadataStartIndex = versionString.firstIndex(of: "+")
        
        let requiredEndIndex = prereleaseStartIndex ?? metadataStartIndex ?? versionString.endIndex
        let requiredCharacters = versionString.prefix(upTo: requiredEndIndex)
        var requiredComponents = requiredCharacters
            .split(separator: ".", maxSplits: 2, omittingEmptySubsequences: false)
            .compactMap(String.init)
            .compactMap { Int($0) }
            .filter { $0 >= 0 }
        
        guard requiredComponents.count > 0 else { return nil }
        
        requiredComponents.reverse()
        self.major = requiredComponents.popLast() ?? 0
        self.minor = requiredComponents.popLast() ?? 0
        self.patch = requiredComponents.popLast() ?? 0
        
        func identifiers(start: String.Index?, end: String.Index) -> [String] {
            guard let start = start else { return [] }
            let identifiers = versionString[versionString.index(after: start)..<end]
            return identifiers.split(separator: ".").map(String.init)
        }
        
        self.prereleaseIdentifiers = identifiers(
            start: prereleaseStartIndex,
            end: metadataStartIndex ?? versionString.endIndex)
        self.buildMetadataIdentifiers = identifiers(start: metadataStartIndex, end: versionString.endIndex)
    }
    
}

extension Version: CustomStringConvertible {
    
    public enum Format {
        case full
        case compact
    }
    
    public func formatted(_ format: Format) -> String {
        var base: String
        
        switch format {
        case .full:
            base = [major, minor, patch].lazy
                .map { "\($0)" }
                .joined(separator: ".")
        case .compact:
            base = [major, minor, patch].lazy
                .filter { $0 != 0 }
                .map { "\($0)" }
                .joined(separator: ".")
        }
        
        if !prereleaseIdentifiers.isEmpty {
            base += "-" + prereleaseIdentifiers.joined(separator: ".")
        }
        if !buildMetadataIdentifiers.isEmpty {
            base += "+" + buildMetadataIdentifiers.joined(separator: ".")
        }
        
        return base.isEmpty ? "0" : base
    }
    
    public var description: String {
        formatted(.full)
    }
    
}

extension Version: Codable {
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let string = try container.decode(String.self)
        
        if let version = Version(string) {
            self.init(version)
        } else {
            self.init(0, 0, 0)
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(description)
    }
    
}
