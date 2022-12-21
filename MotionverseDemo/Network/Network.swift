//
//  Wrappers.swift
//  NetworkTest
//
//  Created by Li Weijie on 2022/8/31.
//

import Foundation
import SwiftUI

@propertyWrapper final class Network<T: API> {
    init(wrappedValue: T) {
        self.wrappedValue = wrappedValue
    }
    private var parameters: [String: Codable]?
    private var body: [String: Codable]?
    private var header: [String: String]?
    private var binding_model: Binding<T.Output>?
    var wrappedValue: T
    var projectedValue: Network {
        self
    }
    func cancel() {
        wrappedValue.task?.cancel()
    }
    // MARK: - Binding
    @discardableResult
    func bind(parameters: [String: Codable]? = nil,
              body: [String: Codable]? = nil,
              header: [String: String]? = nil) -> Self {
        self.parameters = parameters
        self.body = body
        self.header = header
        return self
    }
    @discardableResult
    func bind(model: Binding<T.Output>) -> Self {
        binding_model = model
        return self
    }
    // MARK: - 请求
    /// 发起请求
    @discardableResult
    @MainActor func request() async throws -> T.Output {
        let result = try await NetworkRequest.shared.request(api: wrappedValue, parameters: parameters, body: body, header: header)
        binding_model?.wrappedValue = result
        return result
    }
}
