//
//  Encryption.swift
//  NetworkTest
//
//  Created by Li Weijie on 2022/9/1.
//

import Foundation

protocol Encryption {
    func reset(body: [String: Encodable]?) -> Any?
    func reset(header: [String: String]?) -> [String: String]?
    func reset(parameters: [String: Encodable]?) -> [String: Encodable]?
    func reset<OutPut: Codable>(result: Data) throws -> OutPut
}


struct DefaultEncryption: Encryption {
    func reset(body: [String : Encodable]?) -> Any? {
        return body
    }
    
    func reset(header: [String : String]?) -> [String : String]? {
        header
    }
    
    func reset(parameters: [String : Encodable]?) -> [String: Encodable]? {
        return parameters
    }
    
    func reset<OutPut: Codable>(result: Data) throws -> OutPut {
        throw NetworkError.body_error
    }
}
