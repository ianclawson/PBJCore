//
//  Result+Ext.swift
//  
//
//  Created by Ian Clawson on 1/30/21.
//

import Foundation

public extension Result where Success == Void {
    static var success: Result<Success, Failure> { .success(()) }
}

public extension Result {
    var success: Success? {
        guard case .success(let s) = self else { return nil }
        return s
    }
    var failure: Failure? {
        guard case .failure(let f) = self else { return nil }
        return f
    }
    var isSuccess: Bool { success != nil }
    var isFailure: Bool { failure != nil }
}

public extension Result where Success == Void, Failure == Error {
    init(_ error: Error?) {
        if let error = error {
            self = .failure(error)
        } else {
            self = .success
        }
    }
}
