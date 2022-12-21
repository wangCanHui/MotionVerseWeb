//
//  APPStorageWrapper.swift
//  AvatarWorld
//
//  Created by Li Weijie on 2022/9/29.
//

import SwiftUI
import Combine

enum APPLocalKey: String {
    case phone = "_phone"
    case user = "_user"
    case code = "_code"
    case first_robot = "_first_robot"
    case first_mask = "_first_mask"
}

// MARK: - 协议簇
/// 当数据需要存储至UserDefaults时，该数据类型需要遵循该协议
/// 该协议目前有两个具有默认实现的子协议，LocalCodableKey，LocalRawKey分别为Data存储和原数据存储
/// 当用户需要其他的存储方式时，可实现继承自该协议的协议，并实现默认实现
public protocol LocalUsersKey: Codable {
    associatedtype H: Codable
    /// 数据存储值
    var storageValue: H? { get }
    /// 由存储数据推导出存储之前的原数据
    static func generate(storageValue: H) -> Self?
}
/// LocalUsersKey的子协议，存储方式为Data存储
public protocol LocalCodableKey: LocalUsersKey where H == Data {
    
}
public extension LocalCodableKey {
    var storageValue: Data? {
        return try? _encode(self)
    }
    static func generate(storageValue: Data) -> Self? {
        if let va = try? decode(from: storageValue) {
            return va
        } else {
            return nil
        }
    }
}
/// LocalUsersKey的子协议，存储方式为原数据存储
public protocol LocalRawKey: LocalUsersKey where H == Self {
    
}
extension LocalRawKey {
    public var storageValue: Self? {
        return self
    }
    public static func generate(storageValue: Self) -> Self? {
        return storageValue
    }
}
// MARK: - 基础数据扩展
extension String: LocalRawKey {

}
extension Bool: LocalRawKey {
    
}
extension Data: LocalRawKey {
    
}
extension Int: LocalRawKey {
    
}
extension Int8: LocalRawKey {
    
}
extension Int16: LocalRawKey {
    
}
extension Int32: LocalRawKey {
    
}
extension Int64: LocalRawKey {
    
}
extension Float: LocalRawKey {
    
}
extension Double: LocalRawKey {
    
}

@propertyWrapper struct APPStorageWrapper<Value: LocalUsersKey>: DynamicProperty {
    @ObservedObject private var backingObject: AppStorageWrapperPublish<Value>
    private let key: String
    
    init(wrappedValue value: Value?, _ key: String) {
        self.key = key
        var v: Value?
        if let data = UserDefaults.standard.object(forKey: key) as? Value.H {
            v = Value.generate(storageValue: data) ?? value
        } else {
            v = value
        }
        
        
        let backing = AppStorageWrapperPublish(key: key, value: v)
        self.backingObject = backing
        UserDefaults.standard.addObserver(backing, forKeyPath: key, options: .new, context: nil)
        
    }
    public var wrappedValue: Value? {
        get { self.backingObject.value }
        nonmutating set {
            if let nn = newValue?.storageValue {
                UserDefaults.standard.set(nn, forKey: self.key)
            } else {
                UserDefaults.standard.removeObject(forKey: self.key)
            }
        }
    }
}

fileprivate final class AppStorageWrapperPublish<Value: LocalUsersKey>: NSObject, ObservableObject {
    @Published var value: Value?
    deinit {
        UserDefaults.standard.removeObserver(self, forKeyPath: key)
    }
    private let key: String
    init(key: String, value: Value?) {
        self.key = key
        self.value = value
        super.init()
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let newValue = change?[.newKey] as? Value.H {
            value = Value.generate(storageValue: newValue)
        } else {
            value = nil
        }
    }
}

extension APPStorageWrapper where Value: ExpressibleByNilLiteral {
    
}

extension APPStorageWrapper {
    init(wrappedValue value: Value?, _ key: APPLocalKey) {
        self.init(wrappedValue: value, key.rawValue)
    }
}

