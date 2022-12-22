//
//  ViewController.swift
//  MotionverseDemo
//
//  Created by zksz1 on 2022/12/19.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKScriptMessageHandler,WKNavigationDelegate {
    // MARK: - Properties
    var about: Alert<AboutView>!
    var exchange: Alert<ExchangeView>!
    var robot: Alert<RobotView>!
    
    var exchangeType: ExchangeType = .play
    private var robot_index = 0
    struct Status: Decodable {
        let type: String
        let data: Bool
    }
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        kvo()
    }
    // MARK: - Views
    private func setupViews() {
        _ = titleLabel
        _ = settingButton
        _ = webView
        _ = bottomView
        _ = coverView
        _ = indicatorView
        
//        let url = URL(string: "https://demo.deepscience.cn/poc/index.html")
        let url = URL(string: "https://avatar.deepscience.cn/v1/index.html?code=xVNEJ9ovjQ7EmOlnYO4TlRTB17zMOZOpaNqDyhZLU6BS5oKbvTZvhUc9YqlFaSOe20ooP3VN446VoqK3OoazZyBG4JV4FL+UQc1use3Xlu/deW5WLMq/25h0eOiV4XKk")
//        let url = URL(string: "http://36.138.170.224:8060/avatarx/")
        let request = URLRequest(url: url!, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 60)
        
//        let dataContent = try! Data(contentsOf: url!)
//        let cache = URLCache.shared
//        let response = URLResponse(url: url!, mimeType: "text/html/gz/fbx/wav/untiyweb/otf/ttf/woff/eot/js/json/svg/webp/css/png/jpg/jpeg", expectedContentLength: 0, textEncodingName: "UTF-8")
//        let cacheResponse = CachedURLResponse(response: response, data: dataContent)
//        cache.storeCachedResponse(cacheResponse, for: request)
        
        
        self.webView.load(request)
        //        let current = cache.cachedResponse(for: request)
        //        webView.load(current!.data, mimeType: "text/html/gz/fbx/wav/untiyweb/otf/ttf/woff/eot/js/json/svg/webp/css/png/jpg/jpeg", characterEncodingName: "UTF-8", baseURL: request.url!)
    }
    private func kvo() {
        NotificationCenter.default.addObserver(forName: UIApplication.keyboardWillShowNotification, object: nil, queue: .main) { sender in
            let duration = sender.userInfo?["UIKeyboardAnimationDurationUserInfoKey"] as! Double
            let height = (sender.userInfo?["UIKeyboardFrameEndUserInfoKey"] as! NSValue).cgRectValue.height
            print(height)
            print(sender.userInfo)
            UIView.animate(withDuration: duration) {
                self.bottomView.frame = CGRect(x: 0, y: UIScreen.main.bounds.height - height - 70, width: UIScreen.main.bounds.width, height: 70 + bottom_height)
            }
        }
        NotificationCenter.default.addObserver(forName: UIApplication.keyboardWillHideNotification, object: nil, queue: .main) { sender in
            let duration = sender.userInfo?["UIKeyboardAnimationDurationUserInfoKey"] as! Double
            UIView.animate(withDuration: duration) {
                self.bottomView.frame = CGRect(x: 0, y: UIScreen.main.bounds.height - 70 - bottom_height, width: UIScreen.main.bounds.width, height: 70 + bottom_height)
            }
        }
    }
    // MARK: - Button Actions
    @objc private func buttonAction(_ sender: UIButton) {
        view.endEditing(true)
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let robotAction = UIAlertAction(title: "数字人更换", style: .default) { action in
            self.robot = Alert<RobotView>.alert(content: 201 + bottom_height, intial: RobotView.State(index: self.robot_index), completion: {[weak self] action in
                switch action {
                case let .robot(index, robot):
                    print("更换")
                    self?.robot_index = index
                    self?.webView.evaluateJavaScript("SendMsgToWebGL('{\"type\":\"ChangeCharacter\",\"data\":\"\(robot.abName)\"}')") { d, error in
                        print(error)
                    }
                    break
                }
            })
        }
        let typeAction = UIAlertAction(title: "交互类型更换", style: .default) { action in
            self.exchange = Alert<ExchangeView>.alert(content: 200, intial: ExchangeView.State(type: self.exchangeType)) { [weak self] action in
                switch action {
                case let .type(type):
                    self?.exchangeType = type
                    self?.bottomView.type = type
                    guard let s = self else {
                        return
                    }
                    if type == .answer {
                        s.view.addSubview(s.tipView)
                    } else {
                        s.tipView.removeFromSuperview()
                    }
                }
            }
        }
        let aboutAction = UIAlertAction(title: "关于示例", style: .default) { action in
            self.about = Alert<AboutView>.alert(content: 260, intial: AboutView.State())
//            self.webView.reload()
            self.webView.reloadFromOrigin()
        }
        let cancel = UIAlertAction(title: "取消", style: .cancel)
        alert.addAction(robotAction)
        alert.addAction(typeAction)
        alert.addAction(aboutAction)
        alert.addAction(cancel)
        present(alert, animated: true)
    }
    // MARK: - Lazy UI
    private lazy var navView: UIView = {
        let nav = UIView()
        nav.backgroundColor = .white
        nav.frame = CGRect(x: 0, y: status_height, width: UIScreen.main.bounds.size.width, height: 44)
        view.addSubview(nav)
        return nav
    }()
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Motionverse 示例"
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.frame = CGRect(x: 0, y: 0, width: 150, height: 44)
        label.center = CGPoint(x: UIScreen.main.bounds.width / 2, y: 22)
        navView.addSubview(label)
        return label
    }()
    private lazy var settingButton: UIButton = {
        let button = UIButton(type: .system)
//        button.setImage(UIImage(systemName: "ellipsis.circle"), for: .normal)
        button.setImage(UIImage(named: "icon_setting"), for: .normal)
//        button.setTitle("设置", for: .normal)
        button.frame = CGRect(x: UIScreen.main.bounds.size.width - 45, y: 2, width: 40, height: 40)
        button.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
        navView.addSubview(button)
        return button
    }()
    private lazy var bottomView: BottomView = {
        let bottom = BottomView(frame: CGRect(x: 0, y: UIScreen.main.bounds.height - bottom_height - 70, width: UIScreen.main.bounds.width, height: 70 + bottom_height))
        bottom.backgroundColor = .hex(0xf5f5f5)
        view.addSubview(bottom)
        bottom.delegate = self
        return bottom
    }()
    private lazy var webView: WKWebView = {
        let configuration = WKWebViewConfiguration()
        configuration.allowsInlineMediaPlayback = true
        configuration.mediaTypesRequiringUserActionForPlayback = .video
        configuration.userContentController.add(self, name: "jsBridge")
        let webView = WKWebView(frame: CGRect(x: 0, y: CGRectGetMaxY(navView.frame), width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - CGRectGetMaxY(navView.frame) - 70 - bottom_height), configuration: configuration)
        view.addSubview(webView)
        webView.isUserInteractionEnabled = false
        webView.navigationDelegate = self
        return webView
    }()
    private lazy var tipView: TipView = {
        let tipView = TipView(frame: CGRect(x: 0, y: UIScreen.main.bounds.height - 70 - bottom_height - 100, width: UIScreen.main.bounds.width, height: 100))
        tipView.delegate = self
        return tipView
    }()
    private lazy var coverView: LaunchView = {
        let launch = LaunchView(frame: UIScreen.main.bounds)
        view.addSubview(launch)
        return launch
    }()
    private lazy var toast: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 35))
        label.text = "已发送"
        label.textColor = .white
        label.textAlignment = .center
        label.backgroundColor = .black.withAlphaComponent(0.5)
        label.layer.cornerRadius = 17.5
        label.layer.masksToBounds = true
        label.font = .systemFont(ofSize: 13)
        label.center = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height - bottom_height - 70 - 17.5)
        return label
    }()
    
    private lazy var indicatorView:UIActivityIndicatorView = {
        let aiView = UIActivityIndicatorView(style: .large)
        aiView.center = view.center
        aiView.color = UIColor.gray
        view.addSubview(aiView)
        return aiView
    }()
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == "jsBridge" {
            print(message.body)
            do {
                let status = try Status.decode(from: (message.body as! String).data(using: .utf8) ?? Data())
                if (status.type == "loadAb"){
                    if (status.data){ // 开始
                        indicatorView.startAnimating()
                    }else{ // 结束
                        indicatorView.stopAnimating()
                    }
                }else if (status.type == "playStart"){ // 开始播报

                }else if (status.type == "playEnd"){// 结束播报

                }
            }catch{
                print("异常")
            }
        }
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("网页加载完成")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

extension ViewController: BottomViewDelegate {
    func send(text: String) {
        view.endEditing(true)
        view.addSubview(toast)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.toast.removeFromSuperview()
        }
        if exchangeType == .play {
            self.webView.evaluateJavaScript("SendMsgToWebGL('{\"type\":\"TextBroadcast\",\"data\":\"\(text)\"}')")
        } else {
            self.webView.evaluateJavaScript("SendMsgToWebGL('{\"type\":\"TextAnswerMotion\",\"data\":\"\(text)\"}')")
        }
    }
    func sendAudioFile() {
        self.webView.evaluateJavaScript("SendMsgToWebGL('{\"type\":\"AudioBroadcast\",\"data\":\"https://ds-model-tts.oss-cn-beijing.aliyuncs.com/temp/167144092926757110.wav\"}')")
    }
    func sendRecorder() {
        view.addSubview(toast)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.toast.removeFromSuperview()
        }
        print("dd")
        let detail = Recorder.shared.result
        print(detail)
        self.webView.evaluateJavaScript("SendMsgToWebGL('{\"type\":\"AudioAnswerMotion\",\"data\":\"\(detail)\"}')") { d, error in
            print(error)
            print(d)
        }
    }
}
extension ViewController: TipViewDelegate {
    func send(introduction text: String) {
        self.webView.evaluateJavaScript("SendMsgToWebGL('{\"type\":\"TextAnswerMotion\",\"data\":\"\(text)\"}')")
    }
}
