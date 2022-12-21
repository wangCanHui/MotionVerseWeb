//
//  AboutView.swift
//  MotionverseDemo
//
//  Created by zksz1 on 2022/12/19.
//

import UIKit


class AboutView: UIView, AlertProtocol {
    enum Action {}
    struct State {
        
    }
    // MARK: - Life Cycle
    required init(frame: CGRect, intial: State, completion: ((Action) -> Void)? = nil) {
        super.init(frame: frame)
        backgroundColor = .white
        setupViews()
    }
    required init?(coder: NSCoder) {
        fatalError("cannot impletion")
    }
    var view: UIView {
        self
    }
    // MARK: - Views
    private func setupViews() {
        _ = titleLabel
        _ = logoImageView
        _ = nameLabel
        _ = versionLabel
        _ = line
        _ = contentLabel
    }
    // MARK: - Lazy UI
    private lazy var titleLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 15, width: 120, height: 26))
        label.center = CGPoint(x: UIScreen.main.bounds.width / 2, y: 28)
        label.text = "关于示例"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16, weight: .bold)
        addSubview(label)
        return label
    }()
    private lazy var logoImageView: UIImageView = {
        let logo = UIImageView(frame: CGRect(x: 15, y: CGRectGetMaxY(titleLabel.frame) + 10, width: 40, height: 40))
        logo.image = UIImage(named: "logo")
        addSubview(logo)
        return logo
    }()
    private lazy var nameLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: CGRectGetMaxX(logoImageView.frame) + 10, y: CGRectGetMinY(logoImageView.frame), width: 100, height: 40))
        label.text = "Motionverse"
        label.textColor = .hex(0x69c7eb)
        label.font = .systemFont(ofSize: 15)
        addSubview(label)
        return label
    }()
    private lazy var versionLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: UIScreen.main.bounds.width - 15 - 150, y: CGRectGetMinY(logoImageView.frame), width: 150, height: 40))
        label.text = "Version " + app_version
        label.font = .systemFont(ofSize: 15)
        label.textAlignment = .right
        addSubview(label)
        return label
    }()
    private lazy var line: UIView = {
        let line = UIView(frame: CGRect(x: 15, y: CGRectGetMaxY(logoImageView.frame) + 10, width: UIScreen.main.bounds.width - 30, height: 1))
        line.backgroundColor = .hex(0xf5f5f5)
        addSubview(line)
        return line
    }()
    private lazy var contentLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 15, y: CGRectGetMaxY(line.frame) + 10, width: UIScreen.main.bounds.width - 30, height: 120))
        label.text = "Motionverse数字人开放平台提供数字人 PaaS & SaaS 解决方案，支持以文本、语音、动作等多种方式通过AI智能算法来驱动数字人。提供给客户标准的 PaaS 接口与 SaaS 运营工具，方便客户将数字人能力集成进不同的终端与场景。主要面对的行业包括新零售、政务、金融、运营商、传媒、游戏等，场景包括数字人信息播报等。"
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 14)
        addSubview(label)
        return label
    }()
}
