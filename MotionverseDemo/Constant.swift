//
//  Constant.swift
//  AvatarWorld
//
//  Created by Li Weijie on 2022/9/29.
//

import UIKit

/// 安全区域
let safe_area: UIEdgeInsets = {
    guard let windowscene = UIApplication.shared.connectedScenes.map({ $0 as? UIWindowScene }).compactMap({ $0 }).first, let window = windowscene.windows.first else {
        print(UIApplication.shared.connectedScenes)
        return .zero
    }
    return window.safeAreaInsets
}()
/// 状态栏高度
let status_height: CGFloat = {
    if #available(iOS 11.0, *) {
        return safe_area.top
    } else {
        return UIApplication.shared.statusBarFrame.height
    }
}()
/// 底部安全区域
let bottom_height = safe_area.bottom
let app_version: String = (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String) ?? ""
