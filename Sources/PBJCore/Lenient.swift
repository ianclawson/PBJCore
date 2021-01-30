////
////  Lenient.swift
////  stars2apples
////
////  Created by Ian Clawson on 4/25/20.
////  Copyright © 2020 Ian Clawson Apps. All rights reserved.
////
//
//import Foundation
//​
///// A property wrapper that adjusts Decodable behavior: if the value cannot be parsed due to a type mismatch,
///// it will just be set to `nil` rather than throwing an error on the entire structure.
//@propertyWrapper
//public struct Lenient<T>: Codable where T: Codable {
//    private var value: T?
//​
//    public init(wrappedValue: T?) {
//        self.value = wrappedValue
//    }
//​
//    public var wrappedValue: T? {
//        get { value }
//        set { value = newValue }
//    }
//​
//    public init(from decoder: Decoder) throws {
//        let container = try decoder.singleValueContainer()
//        do {
//            value = try container.decode(T.self)
//        }
//        catch DecodingError.typeMismatch(let type, let context) {
//            // Log about it here, maybe?
//            value = nil
//        }
//    }
//​
//    public func encode(to encoder: Encoder) throws {
//        if let value = self.value {
//            var container = encoder.singleValueContainer()
//            try container.encode(value)
//        }
//    }
//}
//​
//extension Lenient: Equatable where T: Equatable {}
//extension Lenient: Hashable where T: Hashable {}
//​
//extension KeyedDecodingContainer {
//    /// The auto-synthesized Decodable implementation only calls `decodeIfPresent` if the
//    /// stored property type is an Optional. If you have an `@Lenient var name: String?`, then
//    /// the stored property is a non-optional `Lenient<String>`, which means that the
//    /// synthesized implementation calls `decode()` instead, and then yells at us if the key is not
//    /// present. We can get around this by providing this override, which wraps `decode()` to call
//    /// `decodeIfPresent()`. It is preferred by the overload resolution mechanism because it
//    /// has a more specific type.
//    public func decode<T>(_ type: Lenient<T>.Type, forKey key: KeyedDecodingContainer<K>.Key) throws -> Lenient<T> where T : Decodable {
//        return try decodeIfPresent(Lenient<T>.self, forKey: key) ?? Lenient<T>(wrappedValue: nil)
//    }
//}
//​
//extension KeyedEncodingContainer {
//    /// The auto-synthesized Encodable implementation is always going to call `encode()` on the
//    /// underlying `Lenient` object, even if it wraps a nil value, because the `Lenient` itself is
//    /// not nil. If you have an `@Lenient var name: String?`, then the stored property is a
//    /// non-optional `Lenient<String>`, which means that the synthesized implementation calls
//    /// `encode()` on it. We don't actually want to encode a value for a wrapped nil, so we'll only
//    /// pass along the call to the Lenient itself if it has a value.
//    public mutating func encode<T>(_ lenient: Lenient<T>, forKey key: KeyedEncodingContainer<K>.Key) throws where T: Encodable {
//        if let value = lenient.wrappedValue {
//            try encode(value, forKey: key)
//        }
//    }
//}
