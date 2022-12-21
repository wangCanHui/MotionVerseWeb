//
//  BottomView.swift
//  MotionverseDemo
//
//  Created by zksz1 on 2022/12/19.
//

import UIKit

protocol BottomViewDelegate: AnyObject {
    func send(text: String)
    func sendAudioFile()
    func sendRecorder()
}

class BottomView: UIView {
    weak var delegate: BottomViewDelegate?
    var type: ExchangeType = .play {
        didSet {
            guard oldValue != type else {
                return
            }
            if is_text {
                textField.removeFromSuperview()
                sendButton.removeFromSuperview()
            }
            is_text = false
            if type == .play {
                placeholder = "请输入播放文字"
            } else {
                placeholder = "请输入文字问题"
            }
            if type == .play {
                longView.removeFromSuperview()
                addSubview(fileButton)
            } else {
                fileButton.removeFromSuperview()
                addSubview(longView)
            }
        }
    }
    var is_text: Bool = false
    var text: String? {
        set {
            textField.text = newValue
        }
        get {
            textField.text
        }
    }
    var placeholder: String? {
        set {
            textField.placeholder = newValue
        }
        get {
            textField.placeholder
        }
    }
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
        _ = keyboardButton
        _ = fileButton
    }
    // MARK: - Button Actions
    @objc private func buttonAction(_ sender: UIButton) {
        is_text.toggle()
        if is_text {
            if type == .play {
                fileButton.removeFromSuperview()
            } else {
                longView.removeFromSuperview()
            }
            
            addSubview(bg)
            bg.addSubview(textField)
            addSubview(sendButton)
        } else {
            textField.removeFromSuperview()
            bg.removeFromSuperview()
            sendButton.removeFromSuperview()
            if type == .play {
                addSubview(fileButton)
            } else {
                addSubview(longView)
            }
        }
    }
    @objc private func sendAction(_ sender: UIButton) {
        delegate?.send(text: textField.text ?? "")
        textField.text = ""
    }
    @objc private func sendFileAction(_ sender: UIButton) {
        delegate?.sendAudioFile()
    }
    @objc private func longPressAction(_ sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            longView.backgroundColor = .red
            print("开始")
            Recorder.shared.play()
        } else if sender.state == .ended {
            longView.backgroundColor = .white
            print("结束")
            Recorder.shared.stop()
            delegate?.sendRecorder()
        } else if sender.state == .cancelled || sender.state == .failed {
            print("失败")
            longView.backgroundColor = .white
        } else {
            
        }
    }
    // MARK: - Lazy UI
    private lazy var keyboardButton: UIButton = {
        let button = UIButton(type: .custom)
        button.frame = CGRect(x: 15, y: 15, width: 40, height: 40)
        button.setImage(UIImage(systemName: "keyboard"), for: .normal)
        button.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
        addSubview(button)
        return button
    }()
    private lazy var bg: UIView = {
        let bg = UIView(frame:  CGRect(x: 70, y: 15, width: UIScreen.main.bounds.width - 170, height: 40))
        bg.backgroundColor = .white
        addSubview(bg)
        bg.layer.cornerRadius = 20
        bg.layer.masksToBounds = true
        return bg
    }()
    
    private lazy var textField: UITextField = {
        
        let textField = UITextField(frame: CGRect(x: 15, y: 0, width: UIScreen.main.bounds.width - 200, height: 40))
        textField.placeholder = "请输入播放文字"
        textField.font = .systemFont(ofSize: 14)
        bg.addSubview(textField)
        return textField
    }()
    private lazy var sendButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("发送", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .blue
        button.frame = CGRect(x: UIScreen.main.bounds.width - 15 - 70, y: 15, width: 70, height: 40)
        button.layer.cornerRadius = 20
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(sendAction(_:)), for: .touchUpInside)
        addSubview(button)
        return button
    }()
    private lazy var fileButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("点击播报语音文件", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15)
        button.frame = CGRect(x: CGRectGetMaxX(keyboardButton.frame) + 15, y: 15, width: UIScreen.main.bounds.width - CGRectGetMaxX(keyboardButton.frame) - 15 - 15, height: 40)
        button.backgroundColor = .white
        button.layer.cornerRadius = 20
        button.layer.masksToBounds = true
        addSubview(button)
        button.addTarget(self, action: #selector(sendFileAction(_:)), for: .touchUpInside)
        return button
    }()
    private lazy var longView: UILabel = {
        let label = UILabel(frame: CGRect(x: CGRectGetMaxX(keyboardButton.frame) + 15, y: 15, width: UIScreen.main.bounds.width - CGRectGetMaxX(keyboardButton.frame) - 15 - 15, height: 40))
        label.backgroundColor = .white
        label.text = "长按说话"
        label.font = .systemFont(ofSize: 14)
        label.isUserInteractionEnabled = true
        label.layer.cornerRadius = 20
        label.layer.masksToBounds = true
        label.textAlignment = .center
        label.textColor = .black
        addSubview(label)
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressAction(_:)))
        label.addGestureRecognizer(longPress)
        
        return label
    }()
}
