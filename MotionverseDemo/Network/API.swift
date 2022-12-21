//
//  API.swift
//  NetworkTest
//
//  Created by Li Weijie on 2022/8/31.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}
enum RequestEncoding {
    case base
    case json
}
enum EncryptionStrategies {
    case none
    case encrypt(Encryption)
}
enum ResponseEncoding {
    case `default`
    case raw
}

protocol API: AnyObject {
    associatedtype Output: Codable
    var method: HTTPMethod { get }
    var baseUrl: String { get }
    var path: String { get }
    var encrypt_strategies: EncryptionStrategies { get }
    var encoding: RequestEncoding { get }
    var task: URLSessionDataTask? { set get }
    var response_encoding: ResponseEncoding { get }
}
extension API {
    var method: HTTPMethod {
        .get
    }
    
    var encrypt_strategies: EncryptionStrategies {
        .none
    }
    var encoding: RequestEncoding {
        .json
    }
    func bindingTask(_ task: URLSessionDataTask?) {
        self.task = task
    }
    var response_encoding: ResponseEncoding {
        .default
    }
}



// MARK: - Get
final class BaseAPI: API {
    typealias Output = [RobotModel]
    var task: URLSessionDataTask?
    var path: String = ""
    var baseUrl: String = ""
    var method: HTTPMethod = .get
    var response_encoding: ResponseEncoding = .raw
}
struct RobotModel: Codable {
    let abName: String
    let img: String
    let name: String
    let voiceName: String
    let bodyMotion: Int
    let styleTag: String
    let bsRatio: Double
}
