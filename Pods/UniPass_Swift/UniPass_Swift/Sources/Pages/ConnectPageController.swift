//
//  ConnectPage.swift
//  UniWallet
//
//  Created by leven on 2022/11/6.
//

import Foundation
import UIKit
import WebKit

public class ConnectPageController: BasePageViewController {

    let complete: ((UpAccount?, String?) -> Void)
        
    let appSetting: AppSetting
    
    init(url: String, appSetting: AppSetting, complete: @escaping ((UpAccount?, String?) -> Void)) {
        self.appSetting = appSetting
        self.complete = complete
        super.init(url: url)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addJavaScriptHandler(handlerName: "onConnectReady") { [weak self]arg in
            guard let self = self else { return }
            let value: [String: Any] = ["type": "UP_LOGIN",
                                        "appSetting" : ["appName" : self.appSetting.appName ?? "", "appIcon": self.appSetting.appIcon ?? "" , "chain" : self.appSetting.chainType?.rawValue ?? "", "theme": self.appSetting.theme?.rawValue ?? ""]]
            if let jsonData = try? JSONSerialization.data(withJSONObject: value, options: [.fragmentsAllowed]), let jsonString = String.init(data: jsonData, encoding: .utf8) {
                self.evaluateJavaScript("window.onConnectPageReady(\(jsonString))") { res, err in
                    
                }
            }
        }
        
        self.addJavaScriptHandler(handlerName: "onConnectResponse") { [weak self]arg in
            guard let self = self, let argMap = arg as? [String: Any] else { return }
            if let type = argMap["type"] as? String {
                if type == "UP_RESPONSE" {
                    if let payloadData = (argMap["payload"] as? String)?.data(using: .utf8),  let jsonAny = try? JSONSerialization.jsonObject(with: payloadData, options: [.fragmentsAllowed]), let json = jsonAny as? [String: Any] {
                        
                        if (json["type"] as? String) == "DECLINE" {
                            self.complete(nil, "user reject connect")
                            self.gotBack()
                        } else {
                            if let data = json["data"] as? [String: Any] {
                                let upAccount = UpAccount(address: data["address"] as? String ?? "" , email: data["email"]  as? String ?? "", newborn: data["newborn"] as? Int ?? 0)
                                self.complete(upAccount, nil)
                                self.gotBack()
                            } else {
                                self.complete(nil, "data decode error")
                                self.gotBack()
                            }
                        }
                    }
                }
            } else {
                self.complete(nil, "invalid body data")
                self.gotBack()
            }
        }
    }
}
