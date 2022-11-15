//
//  UniPassWebViewController.swift
//  UniWallet
//
//  Created by leven on 2022/11/6.
//

import Foundation
import UIKit
public class UniPassController {
    
    public static let UniPassDidCreateNotification = "UniPassDidLoad"
    
    var config: UniPassConfig
    
    // 连接web3网络
//    var authProvider: Web3Provider?
    
    public init(option: UniPassOption) {
        let chainType = option.appSetting?.chainType ?? .polygon
        let env = option.env ?? .testnet
        let rpcUrl = option.nodeRPC ?? getRpcUrl(env: env, chainType: chainType)
        let appSetting = option.appSetting ?? AppSetting(appName: nil, appIcon: nil, theme: .dark, chainType: chainType)
        self.config = UniPassConfig(nodeRPC: rpcUrl, chainType: chainType, env: env, domain: option.domain ?? upDomain, proto: option.proto ?? "https", appSetting: appSetting)
    }
    
    static public func getUniPassPage() -> UIViewController {
        let vc = UniPassViewController(url: "https://testnet.wallet.unipass.id")
        return vc
    }
    
    public func connect(in vc: UIViewController, complete:  @escaping ((UpAccount?, String?) -> Void)) {
        if let upAccount = Storage.getUpAccount() {
            complete(upAccount, nil)
        } else {
            let url = getWalletUrl(messageType: .upConnect, domain: config.domain, proto: config.proto)
            let connectVc = ConnectPageController(url: url, appSetting: config.appSetting) { account, errMsg in
                if let account = account {
                    Storage.saveUpAccount(account: account)
                }
                complete(account, errMsg)
            }
            vc.present(UINavigationController(rootViewController: connectVc), animated: true, completion: nil)
        }
    }
    
    public func sendTransaction(in vc: UIViewController, _ transaction: TransactionMessage, complete: @escaping ((String?, String?) -> Void)) {
        if let _ = Storage.getUpAccount() {
            let url = getWalletUrl(messageType: .upSendTransaction, domain: config.domain, proto: config.proto)
            let sendVC = SendTransactionPageController(url: url, transaction: transaction, appSetting: config.appSetting, complete: complete)
            vc.present(UINavigationController(rootViewController: sendVC), animated: true, completion: nil)
        } else {
            complete(nil, "invalid user info")
        }
    }
    
}
