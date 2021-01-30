//
//  Environment.swift
//  
//
//  Created by Ian Clawson on 1/30/21.
//

import Foundation

public enum Environment: String {
    case development = "Development"
    case staging = "Staging"
    case production = "Production"
}

public extension Environment {
    
    // MARK: - Keys
    enum Keys {
        enum Plist {
            static let rootURL = "ROOT_URL"
            static let exampleApiKey = "EXAMPLE_API_KEY"
            static let environment = "ENVIRONMENT"
        }
    }
    
    // MARK: - Plist
    private static let infoDictionary: [String: Any] = {
        guard let dict = Bundle.main.infoDictionary else {
            fatalError("Plist file not found")
        }
        return dict
    }()
    
    // MARK: - Plist values
    static let rootURL: String = {
        guard let rootURLstring = Environment.infoDictionary[Keys.Plist.rootURL] as? String else {
            fatalError("Root URL not set in plist for this environment")
        }
        return rootURLstring
    }()
    
    static let exampleApiKey: String = {
        guard let apiKey = Environment.infoDictionary[Keys.Plist.exampleApiKey] as? String else {
            fatalError("Split API key not set in plist for this environment")
        }
        return apiKey
    }()
    
    static let environment: Environment = {
        guard let environment = Environment.infoDictionary[Keys.Plist.environment] as? String else {
            fatalError("Environment Key not set in plist for this environment")
        }
        guard let scheme = Environment(rawValue: environment) else {
            return .production
        }
        return scheme
    }()
}
