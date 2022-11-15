//
//  SendTransactionPageController.swift
//  UniPass_Swift
//
//  Created by leven on 2022/11/14.
//

import Foundation
import Web3
import BigInt
 class SendTransactionPageController: BasePageViewController {
    
    let complete: ((String?, String?) -> Void)
        
    let appSetting: AppSetting
    
    let transaction: TransactionMessage
    
    init(url: String, transaction: TransactionMessage ,appSetting: AppSetting, complete: @escaping ((String?, String?) -> Void)) {
        self.appSetting = appSetting
        self.transaction = transaction
        self.complete = complete
        super.init(url: url)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addJavaScriptHandler(handlerName: "onSendTransactionReady") { [weak self]arg in
            guard let self = self else { return }
            let value: [String: Any] = ["type": "UP_TRANSACTION",
                                        "appSetting" : ["appName" : self.appSetting.appName ?? "", "appIcon": self.appSetting.appIcon ?? "", "chain" : self.appSetting.chainType?.rawValue ?? "", "theme": self.appSetting.theme?.rawValue ?? ""],
                                        "payload": [
                                            "from": self.transaction.from,
                                            "to": self.transaction.to,
                                            "value": self.transaction.value,
                                            "data": self.transaction.data,
                                        ],
            ]
            if let jsonData = try? JSONSerialization.data(withJSONObject: value, options: [.fragmentsAllowed]), let jsonString = String.init(data: jsonData, encoding: .utf8) {
                self.evaluateJavaScript("window.onSendTransactionReady(\(jsonString))") { res, err in
                    
                }
            }
        }
        
        self.addJavaScriptHandler(handlerName: "onSendTransactionResponse") { [weak self]arg in
            guard let self = self, let argMap = arg as? [String: Any] else { return }
            if let type = argMap["type"] as? String {
                if type == "UP_RESPONSE" {
                    if let payloadData = (argMap["payload"] as? String)?.data(using: .utf8),  let jsonAny = try? JSONSerialization.jsonObject(with: payloadData, options: [.fragmentsAllowed]), let json = jsonAny as? [String: Any] {
                        
                        if (json["type"] as? String) == "DECLINE" {
                            self.complete(nil, "user reject connect")
                            self.gotBack()
                        } else {
                            if let txHash = json["data"] as? String {
                                self.complete(txHash, nil)
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
