//
//  TipView.swift
//  MotionverseDemo
//
//  Created by zksz1 on 2022/12/20.
//

import UIKit
protocol TipViewDelegate: AnyObject {
    func send(introduction text: String)
}

class TipView: UIView {
    weak var delegate: TipViewDelegate?
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    required init?(coder: NSCoder) {
        fatalError("cannot impletion")
    }
    // MARK: - Views
    private func setupViews() {
        _ = tipLabel
        _ = platformButton
        _ = technologyButton
        _ = businessButton
    }
    // MARK: - Button Actions
    @objc private func buttonAction(_ sender: UIButton) {
        let title = sender.title(for: .normal)!
        delegate?.send(introduction: title)
    }
    // MARK: - Lazy UI
    private lazy var tipLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 15, y: 0, width: 150, height: 25))
        label.text = "您可以问一下问题："
        label.font = .systemFont(ofSize: 14)
        label.textColor = .hex(0x69c7eb)
        addSubview(label)
        return label
    }()
    private lazy var platformButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("平台介绍", for: .normal)
        button.setTitleColor(.hex(0x69c7eb), for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14)
        button.layer.cornerRadius = 20
        button.layer.masksToBounds = true
        button.layer.borderColor = UIColor.hex(0x69c7eb).cgColor
        button.layer.borderWidth = 1
        button.frame = CGRect(x: 15, y: CGRectGetMaxY(tipLabel.frame) + 10, width: 100, height: 35)
        addSubview(button)
        button.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
        return button
    }()
    private lazy var technologyButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("技术介绍", for: .normal)
        button.setTitleColor(.hex(0x69c7eb), for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14)
        button.layer.cornerRadius = 20
        button.layer.masksToBounds = true
        button.layer.borderColor = UIColor.hex(0x69c7eb).cgColor
        button.layer.borderWidth = 1
        button.frame = CGRect(x: CGRectGetMaxX(platformButton.frame) + 15, y: CGRectGetMaxY(tipLabel.frame) + 10, width: 100, height: 35)
        addSubview(button)
        button.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
        return button
    }()
    private lazy var businessButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("业务介绍", for: .normal)
        button.setTitleColor(.hex(0x69c7eb), for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14)
        button.layer.cornerRadius = 20
        button.layer.masksToBounds = true
        button.layer.borderColor = UIColor.hex(0x69c7eb).cgColor
        button.layer.borderWidth = 1
        button.frame = CGRect(x: CGRectGetMaxX(technologyButton.frame) + 15, y: CGRectGetMaxY(tipLabel.frame) + 10, width: 100, height: 35)
        addSubview(button)
        button.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
        return button
    }()
}
