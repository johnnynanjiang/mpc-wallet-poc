//
//  BasePageViewController.swift
//  UniPass_Swift
//
//  Created by leven on 2022/11/11.
//

import Foundation
import UIKit
import WebKit

public class BasePageViewController: UIViewController, WKNavigationDelegate, WKScriptMessageHandler {

    private let titleKeyPath = "title"
    private let estimatedProgressKeyPath = "estimatedProgress"

    lazy var webView: WKWebView = {
        let config = WKWebViewConfiguration()
        config.preferences = WKPreferences()
        config.preferences.minimumFontSize = 10
        config.preferences.javaScriptEnabled = true
        config.preferences.javaScriptCanOpenWindowsAutomatically = true
        config.processPool = WKProcessPool()
        config.userContentController = WKUserContentController()
        let webView = WKWebView(frame: CGRect.zero, configuration: config)
        webView.addObserver(self, forKeyPath: titleKeyPath, options: .new, context: nil)
        webView.addObserver(self, forKeyPath: estimatedProgressKeyPath, options: .new, context: nil)
        webView.allowsBackForwardNavigationGestures = true
        if #available(iOS 9.0, *) {
            webView.allowsLinkPreview = true
        }
        webView.navigationDelegate = self
        webView.backgroundColor = UIColor.white
        return webView
    }()
        
    let url: String
        
    init(url: String) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }
    
    private var handlers: [String: ((Any) -> Void)] = [:]
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        webView.removeObserver(self, forKeyPath: titleKeyPath)
        webView.removeObserver(self, forKeyPath: estimatedProgressKeyPath)
    }
    
    public func addJavaScriptHandler(handlerName: String, callBack: @escaping ((Any) -> Void)) {
        handlers[handlerName] = callBack
    }
    
    
    public func evaluateJavaScript(_ jsString: String, callback: ((Any?, Error?) -> Void)? = nil) {
        self.webView.evaluateJavaScript(jsString, completionHandler: callback)
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.webView.frame = self.view.bounds
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.webView.configuration.userContentController.addUserScript(JAVASCRIPT_BRIDGE_JS_PLUGIN_SCRIPT)
        self.webView.configuration.userContentController.add(self, name: "callHandler")
        self.view.addSubview(self.webView)
        if let webUrl = URL(string: url) {
            self.webView.load(URLRequest(url: webUrl))
        }
    }
    
    
    
    public override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == titleKeyPath {
            self.title = change?[.newKey] as? String
        } else if keyPath == estimatedProgressKeyPath {
            if let progress = change?[.newKey] as? Double {
                print(progress)
                if progress == 1.0 {
                    NotificationCenter.default.post(name: .init(rawValue: UniPassController.UniPassDidCreateNotification), object: nil)
                }
            }
        }
    }
    
    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == "callHandler",
           let body = message.body as? [String: Any?],
           let handlerName = body["handlerName"] as? String {
            
            let args = body["args"] as! String
            var argsValue: [String: Any] = [:]
            if let jsonData = args.data(using: .utf8), let mapBody =  try? JSONSerialization.jsonObject(with: jsonData, options: [.fragmentsAllowed]) {
                argsValue = (mapBody as? [[String: Any]] ?? []).first ?? [:]
            }
            if let callback = self.handlers[handlerName] {
                callback(argsValue)
            }
        }

    }
    
    func gotBack() {
        if (self.navigationController?.viewControllers.count ?? 0) > 1 {
            self.navigationController?.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
}
