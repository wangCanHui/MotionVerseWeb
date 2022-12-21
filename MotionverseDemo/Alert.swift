//
//  Alert.swift
//  MotionverseDemo
//
//  Created by zksz1 on 2022/12/19.
//

import UIKit

protocol AlertProtocol {
    associatedtype Action
    associatedtype State
    var view: UIView { get }
    init(frame: CGRect, intial: State, completion: ((Action) -> Void)?)
}


final class Alert<Content: AlertProtocol>: NSObject {
    let bg: UIView
    var content: Content!
    private let height: CGFloat
    // MARK: - Init
    init(content height: CGFloat, intial: Content.State, completion: ((Content.Action) -> Void)?) {
        self.height = height
        bg = UIView(frame: UIScreen.main.bounds)
        bg.backgroundColor = .black.withAlphaComponent(0.5)
        super.init()
        content = Content(frame: CGRect(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: height), intial: intial) { [weak self] action in
            completion?(action)
            self?.hidden()
        }
        content.view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        content.view.layer.cornerRadius = 10
        content.view.layer.masksToBounds = true
        if let windowscene = UIApplication.shared.connectedScenes.map({ $0 as? UIWindowScene }).compactMap({ $0 }).first, let window = windowscene.windows.first {
            window.isUserInteractionEnabled = true
            window.addSubview(bg)
            window.addSubview(content.view)
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction(_:)))
        bg.addGestureRecognizer(tap)
    }
    @objc private func tapAction(_ sender: UITapGestureRecognizer) {
        hidden()
    }
    private func show() {
        UIView.animate(withDuration: 0.3) {
            self.content.view.frame = CGRect(x: 0, y: UIScreen.main.bounds.height - self.height, width: UIScreen.main.bounds.width, height: self.height)
        }
    }
    private func hidden() {
        UIView.animate(withDuration: 0.3) {
            self.content.view.frame = CGRect(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: self.height)
        } completion: { flag in
            self.bg.removeFromSuperview()
            self.content.view.removeFromSuperview()
        }
    }
}
extension Alert {
    static func alert(content height: CGFloat, intial: Content.State, completion: ((Content.Action) -> Void)? = nil) -> Alert {
        let alert = Alert.init(content: height, intial: intial, completion: completion)
        alert.show()
        return alert
    }
}
