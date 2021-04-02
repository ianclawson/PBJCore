//
//  StringReplaceViaRegex.swift
//  PBJCore
//
//  Created by Ian Clawson on 1/20/21.
//  From: Dave DeLong via Slack.
//

import Foundation

//final class StringReplacementsTests: XCTestCase {
//    func testIdentity() {
//        let input = "Hello, world"
//        let output = input.replace(using: [1: "Goodbye"])
//        XCTAssertEqual(input, output)
//    }
//    func testSingle() {
//        let input = "{1}, world"
//        let output = input.replace(using: [1: "Goodbye"])
//        XCTAssertEqual("Goodbye, world", output)
//    }
//    func testMultiple() {
//        let input = "{1}, {1}"
//        let output = input.replace(using: [1: "Goodbye"])
//        XCTAssertEqual("Goodbye, Goodbye", output)
//    }
//    func testMultipleReplacements() {
//        let input = "{1}, {2}"
//        let output = input.replace(using: [1: "Goodbye", 2: "world"])
//        XCTAssertEqual("Goodbye, world", output)
//    }
//    func testMultipleOutOfOrderReplacements() {
//        let input = "{2} {1}; {1}, {2}"
//        let output = input.replace(using: [1: "Goodbye", 2: "world"])
//        XCTAssertEqual("world Goodbye; Goodbye, world", output)
//    }
//    func testRecursive() {
//        let input = "{1}"
//        let output = input.replace(using: [1: "a{1}"])
//        XCTAssertEqual("a{1}", output)
//    }
//    func testMultipleRecursive() {
//        let input = "{1} {2}"
//        let output = input.replace(using: [1: "a{2}", 2: "a{1}"])
//        XCTAssertEqual("a{2} a{1}", output)
//    }
//    func testMissing() {
//        let input = "{1}"
//        let output = input.replace(using: [:])
//        XCTAssertEqual("{1}", output)
//    }
//}

private let groupRegex = try! NSRegularExpression(pattern: #"\{(\d+)\}"#, options: [])

public extension String {
    func replace(using replacements: [Int: String]) -> String {
        let ns = self as NSString
        let matches = groupRegex.matches(in: self, options: [], range: NSRange(location: 0, length: ns.length))
        var endOfRange = ns.length
        var parts = Array<String>()
        for match in matches.reversed() {
            let r = match.range(at: 0)
            let end = r.upperBound
            let segmentAfter = NSRange(location: end, length: endOfRange - end)
            if segmentAfter.length > 0 {
                let sub = ns.substring(with: segmentAfter)
                parts.append(sub)
            }
            let indexRange = match.range(at: 1)
            if let integer = Int(ns.substring(with: indexRange)), let replacement = replacements[integer] {
                parts.append(replacement)
            } else {
                parts.append(ns.substring(with: r))
            }
            endOfRange = r.lowerBound
        }
        if endOfRange > 0 {
            parts.append(ns.substring(to: endOfRange))
        }
        return parts.reversed().joined()
    }
}
