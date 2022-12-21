//
//  Color.swift
//  AvatarWorld
//
//  Created by Li Weijie on 2022/8/26.
//

import UIKit

extension UIColor {
    static func hex(_ color: UInt) -> UIColor {
        UIColor(red: CGFloat((color & 0xFF0000) >> 16) / 255.0, green: CGFloat((color & 0x00FF00) >> 8) / 255.0, blue: CGFloat((color & 0x0000FF) >> 0) / 255.0, alpha: 1)
    }
}

