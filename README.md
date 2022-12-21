# WebView 接入文档

## WebView的初始化

```swift
let configuration = WKWebViewConfiguration()
configuration.allowsInlineMediaPlayback = true
configuration.mediaTypesRequiringUserActionForPlayback = .video
configuration.userContentController.add(self, name: "jsBridge")
let webView = WKWebView(frame: CGRect(x: 0, y: CGRectGetMaxY(navView.frame), width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - CGRectGetMaxY(navView.frame) - 70 - bottom_height), configuration: configuration)
view.addSubview(webView)
```

## WebView加载指定网页

```swift
let url = URL(string: "https://demo.deepscience.cn/poc/index.html")
let request = URLRequest(url: url!, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 60)
webView.load(request)
```

## WebView中执行js函数

```swift
// 更换数字人 type: 方法名 data:方法参数【数字人的索引】
webView.evaluateJavaScript("SendMsgToWebGL('{\"type\":\"ChangeCharacter\",\"data\":\"\(robot.abName)\"}')")

// 播报声音文件地址 type: 方法名 data:方法参数【声音文件URL地址】
webView.evaluateJavaScript("SendMsgToWebGL('{\"type\":\"AudioBroadcast\",\"data\":\"https://ds-model-tts.oss-cn-beijing.aliyuncs.com/temp/167144092926757110.wav\"}')")

// 播报文本 type: 方法名 data:方法参数【播报的文本】
webView.evaluateJavaScript("SendMsgToWebGL('{\"type\":\"TextBroadcast\",\"data\":\"\(text)\"}')")

// 问答 文字问答 type: 方法名 data:方法参数【问题的文本】
webView.evaluateJavaScript("SendMsgToWebGL('{\"type\":\"TextAnswerMotion\",\"data\":\"\(text)\"}')")

// 问答 语音问答 type: 方法名 data:方法参数【录音流的BASE64编码】
webView.evaluateJavaScript("SendMsgToWebGL('{\"type\":\"AudioAnswerMotion\",\"data\":\"\(detail)\"}')")
```

## WebView网页加载完成的回调

```swift
webView.navigationDelegate = self; // WKNavigationDelegate
func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    print("网页加载完成")
}
```

## APP收到WebView发过来的js消息

```swift
func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
    if message.name == "jsBridge" {
        print(message.body)
    }
}
```
