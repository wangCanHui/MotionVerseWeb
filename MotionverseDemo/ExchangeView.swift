//
//  ExchangeView.swift
//  MotionverseDemo
//
//  Created by zksz1 on 2022/12/20.
//

import UIKit

enum ExchangeType {
    case play
    case answer
}

class ExchangeView: UIView, AlertProtocol {
    enum Action {
        case type(ExchangeType)
    }
    struct State {
        var type: ExchangeType
    }
    var completion: ((Action) -> Void)?
    var type: ExchangeType = .play
    // MARK: - Init
    required init(frame: CGRect, intial: State, completion: ((Action) -> Void)? = nil) {
        self.completion = completion
        self.type = intial.type
        super.init(frame: frame)
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
        backgroundColor = .white
        _ = titleLabel
        _ = sureButton
        _ = playButton
        _ = answerButton
        if self.type == .play {
            playButton.isSelected = true
            playButton.layer.borderColor = UIColor.hex(0x69c7eb).cgColor
        } else {
            answerButton.isSelected = true
            answerButton.layer.borderColor = UIColor.hex(0x69c7eb).cgColor
        }
    }
    // MARK: - Button Actions
    @objc private func sureAction(_ sender: UIButton) {
        completion?(.type(type))
    }
    @objc private func playAction(_ sender: UIButton) {
        guard !sender.isSelected else {
            return
        }
        type = .play
        sender.isSelected = true
        sender.layer.borderColor = UIColor.hex(0x69c7eb).cgColor
        answerButton.isSelected = false
        answerButton.layer.borderColor = UIColor.hex(0xf7f7f7).cgColor
    }
    @objc private func answerAction(_ sender: UIButton) {
        guard !sender.isSelected else {
            return
        }
        type = .answer
        sender.isSelected = true
        sender.layer.borderColor = UIColor.hex(0x69c7eb).cgColor
        playButton.isSelected = false
        playButton.layer.borderColor = UIColor.hex(0xf7f7f7).cgColor
    }
    // MARK: - Lazy UI
    private lazy var titleLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 15, width: 120, height: 26))
        label.center = CGPoint(x: UIScreen.main.bounds.width / 2, y: 28)
        label.text = "交互类型更换"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16, weight: .bold)
        addSubview(label)
        return label
    }()
    private lazy var playButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("播报", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(.hex(0x69c7eb), for: .selected)
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.layer.borderColor = UIColor.hex(0xf5f5f5).cgColor
        button.layer.borderWidth = 1
        button.titleLabel?.font = .systemFont(ofSize: 14)
        button.frame = CGRect(x: 15, y: CGRectGetMaxY(titleLabel.frame) + 10, width: UIScreen.main.bounds.width - 30, height: 45)
        button.addTarget(self, action: #selector(playAction(_:)), for: .touchUpInside)
        addSubview(button)
        return button
    }()
    private lazy var answerButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("问答", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(.hex(0x69c7eb), for: .selected)
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.layer.borderColor = UIColor.hex(0xf5f5f5).cgColor
        button.layer.borderWidth = 1
        button.titleLabel?.font = .systemFont(ofSize: 14)
        button.frame = CGRect(x: 15, y: CGRectGetMaxY(playButton.frame) + 10, width: UIScreen.main.bounds.width - 30, height: 45)
        button.addTarget(self, action: #selector(answerAction(_:)), for: .touchUpInside)
        addSubview(button)
        return button
    }()
    private lazy var sureButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("确定", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 13)
        button.frame = CGRect(x: UIScreen.main.bounds.width - 15 - 50, y: 5, width: 50, height: 46)
        button.addTarget(self, action: #selector(sureAction(_:)), for: .touchUpInside)
        addSubview(button)
        return button
    }()
}
