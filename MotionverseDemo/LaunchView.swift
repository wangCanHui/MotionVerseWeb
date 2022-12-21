//
//  LaunchView.swift
//  MotionverseDemo
//
//  Created by zksz1 on 2022/12/21.
//

import UIKit

class LaunchView: UIView {
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
        backgroundColor = .white
        _ = logoImageView
        _ = nameLabel
        _ = detailLabel
        _ = commitButton
    }
    // MARK: - Button Actions
    @objc private func buttonAction(_ sender: UIButton) {
        self.removeFromSuperview()
    }
    // MARK: - Lazy UI
    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        imageView.center = CGPoint(x: UIScreen.main.bounds.width / 2, y: status_height + 90)
        imageView.image = UIImage(named: "logo")
        addSubview(imageView)
        return imageView
    }()
    private lazy var nameLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 25))
        label.text = "Motionverse"
        label.font = .systemFont(ofSize: 15)
        label.textColor = .hex(0x69c7eb)
        label.textAlignment = .center
        label.center = CGPoint(x: UIScreen.main.bounds.width / 2, y: CGRectGetMaxY(logoImageView.frame) + 17.5)
        addSubview(label)
        return label
    }()
    private lazy var detailLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 40, y: CGRectGetMaxY(nameLabel.frame) + 30, width: UIScreen.main.bounds.width - 80, height: 120))
        label.text = "Motionverse数字人开放平台提供数字人 Paas & Saas 解決方察，支持以文本、语音、动作等多种方式通过A智能算法来驱动数字人。提供给客户标准的 Paas 接口与 Saas 运营工具，方便客户将数字人能力集成进不同的终端与场最。主要面对的行业包括新零售、政务、金融、运苔商、传媒．游戏等，场暴包括数字人信息播报等。"
        label.font = .systemFont(ofSize: 13)
        label.numberOfLines = 0
        addSubview(label)
        return label
    }()
    private lazy var commitButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("立即体验", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14)
        button.backgroundColor = .hex(0x69c7eb)
        button.frame = CGRect(x: 50, y: CGRectGetMaxY(detailLabel.frame) + 20, width: UIScreen.main.bounds.width - 100, height: 40)
        button.layer.cornerRadius = 20
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
        addSubview(button)
        return button
    }()
}
