//
//  NetworkRequest.swift
//  NetworkTest
//
//  Created by Li Weijie on 2022/8/31.
//

import Foundation
import SwiftUI

enum NetworkError: Error {
    case url_error
    case data_empty
    case body_error
    case json_encoding_error(error: Error)
    case service_error(error: Error)
    case result_decoding_error(error: Error)
    case response_error(_ code: Int, _ message: String)
    case response_data_empty
}

struct NetworkResult<T: Codable>: Codable {
    let code: Int
    let message: String
    let data: T?
}


final class NetworkRequest {
    static let shared: NetworkRequest = {
       let request = NetworkRequest()
        return request
    }()
    // MARK: - Init
    private let session = URLSession.shared
    // MARK: - Request
    @discardableResult
    func request<T: API>(api: T, parameters: [String: Encodable]? = nil, body: [String: Encodable]? = nil, header: [String: String]? = nil) async throws -> T.Output {
        // request组装
        let request = try createRequest(api: api, parameters: parameters, body: body, header: header)
        
        // 请求
        let result = try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<(Data, URLResponse), Error>) in
            let task = session.dataTask(with: request) { data, response, error in
                if let error = error {
                    continuation.resume(throwing: NetworkError.service_error(error: error))
                } else if let data = data, let response = response {
                    continuation.resume(returning: (data, response))
                } else {
                    continuation.resume(throwing: NetworkError.data_empty)
                }
            }
            api.bindingTask(task)
            task.resume()
        }.0
        // 组装输出数据
        return try reset(result: result, strategies: api.encrypt_strategies, is_raw: api.response_encoding == .raw)
        
    }
}

extension NetworkRequest {
    private func createRequest<T: API>(api: T, parameters: [String: Encodable]? = nil, body: [String: Encodable]? = nil, header: [String: String]? = nil) throws -> URLRequest {
        let url_str = api.baseUrl + api.path
        guard var url = URL(string: url_str) else {
            throw NetworkError.url_error
        }
        let parameters = reset(parameters: parameters, strategies: api.encrypt_strategies)
        if let parameters = parameters, parameters.count > 0 {
            var urlComponents = URLComponents()
            urlComponents.scheme = url.scheme
            urlComponents.host = url.host
            urlComponents.path = url.path
            urlComponents.port = url.port
            urlComponents.queryItems = parameters.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
            url = urlComponents.url!
        }
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 10)
        request.httpMethod = api.method.rawValue
        
        let header = reset(headers: header, strategies: api.encrypt_strategies)
        if let header = header {
            for (key, value) in header {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }
        
        let body = reset(body: body, strategies: api.encrypt_strategies)
        if let body = body, api.method != .get {
            switch api.encoding {
            case .base:
                guard let body = body as? [String: Encodable] else {
                    throw NetworkError.body_error
                }
                request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
                var requestBodyComponents = URLComponents()
                requestBodyComponents.queryItems = body.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
                request.httpBody = requestBodyComponents.query?.data(using: .utf8)
            case .json:
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
                    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                    request.httpBody = jsonData
                } catch {
                    throw NetworkError.json_encoding_error(error: error)
                }
                
            }
        }
        return request
    }
    func reset(parameters: [String: Encodable]?, strategies: EncryptionStrategies) -> [String: Encodable]? {
        switch strategies {
        case .none:
            return parameters
        case .encrypt(let encryption):
            return encryption.reset(parameters: parameters)
        }
    }
    func reset(headers: [String: String]?, strategies: EncryptionStrategies) -> [String: String]? {
        switch strategies {
        case .none:
            return headers
        case .encrypt(let encryption):
            return encryption.reset(header: headers)
        }
    }
    func reset(body: [String: Encodable]?, strategies: EncryptionStrategies) -> Any? {
        switch strategies {
        case .none:
            return body
        case .encrypt(let encryption):
            return encryption.reset(body: body)
        }
    }
    func reset<Output: Codable>(result: Data, strategies: EncryptionStrategies, is_raw: Bool) throws -> Output {
        switch strategies {
        case .none:
            do {
                print(String(data: result, encoding: .utf8) ?? "")
                if is_raw {
                    let output = try Output.decode(from: result)
                    return output
                } else {
                    let output = try NetworkResult<Output>.decode(from: result)
                    if let data = output.data {
                        return data
                    } else if output.code == 200 {
                        throw NetworkError.response_data_empty
                    } else {
                        throw NetworkError.response_error(output.code, output.message)
                    }
                }
            } catch let error as NetworkError {
                throw error
            } catch {
                throw NetworkError.result_decoding_error(error: error)
            }
        case .encrypt(let encryption):
            return try encryption.reset(result: result)
        }
    }
}

extension UserDefaults {
    
}
