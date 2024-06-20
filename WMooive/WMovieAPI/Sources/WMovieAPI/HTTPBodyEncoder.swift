//
//  HTTPBodyEncoder.swift
//
//
//  HTTPBodyEncoder by Halit Baskurt on 19.06.2024.
//

import Foundation


public protocol HTTPBodyEncoder {
    func encode<D:Codable>(for data:D) -> Data?
}

public struct HTTPBodyEncoderImpl: HTTPBodyEncoder {
    public init() { }
    public func encode<D:Codable>(for data:D) -> Data? {
        let encoder = JSONEncoder()
        return try? encoder.encode(data)
    }
}
