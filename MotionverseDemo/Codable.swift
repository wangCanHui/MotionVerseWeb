//
//  File 2.swift
//  
//
//  Created by Li Weijie on 2021/6/25.
//

import Foundation

/// 编码
private let encoder = JSONEncoder()
private let decoder = JSONDecoder()
//private let decoder = JSONDecoder()

public extension Encodable {
    func convertJson() -> String? {
        do {
            let data = try _encode(self)
            return String(data: data, encoding: .utf8)
        } catch {
            return nil
        }
    }
    func encode() throws -> Data {
        try _encode(self)
    }
}
public extension Decodable {
    static func decode(from data: Data) throws -> Self {
        try _decode(Self.self, from: data)
    }
}

func _decode<T: Decodable>(_ type: T.Type, from data: Data) throws -> T {
    try decoder.decode(type, from: data)
}
func _encode<T: Encodable>(_ value: T) throws -> Data {
    try encoder.encode(value)
}
