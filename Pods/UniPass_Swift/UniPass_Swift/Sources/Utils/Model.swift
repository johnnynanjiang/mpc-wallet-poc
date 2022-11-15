//
//  Model.swift
//  UniWallet
//
//  Created by leven on 2022/11/6.
//

import Foundation
public enum Environment: Int {
    case testnet
    case mainnet
}

public enum ChainType: String {
    case polygon
    case bsc
    case rangers
}

public enum UniPassTheme: String {
    case light
    case dark
}

public enum MessageType {
    case upReady
    case upSignMessage
    case upSendTransaction
    case upConnect
}

public class UpAccount {
    public var address: String
    public var email: String
    public var newborn: Int
    
    public init(address: String, email: String, newborn: Int) {
        self.address = address
        self.email = email
        self.newborn = newborn
    }
    
    public func toJsonString() -> String? {
        let map = ["address": self.address, "email": self.email, "newborn": self.newborn] as [String : Any]
        if let data = try? JSONSerialization.data(withJSONObject: map, options: [.fragmentsAllowed]), let jsonString = String.init(data: data, encoding: .utf8) {
            return jsonString
        }
        return nil
    }

}


public class TransactionMessage {
    public var from: String
    public var to: String
    public var value: String
    public var data: String
    
    public init(from: String, to: String, value: String, data: String) {
        self.from = from
        self.to = to
        self.value = value
        self.data = data
    }
}

public class AppSetting {
    public var appName: String?
    public var appIcon: String?
    public var theme: UniPassTheme?
    public var chainType: ChainType?
    
    public init(appName: String?, appIcon: String?, theme: UniPassTheme?, chainType: ChainType?) {
        self.appName = appName
        self.appIcon = appIcon
        self.theme = theme
        self.chainType = chainType
    }
}

public class UniPassOption {
    public var nodeRPC: String?
    public var env: Environment?
    public var domain: String?
    public var proto: String?
    public var appSetting: AppSetting?
    
    public init(nodeRPC: String? = nil, env: Environment? = nil, domain: String? = nil, proto: String? = nil, appSetting: AppSetting? = nil) {
        self.nodeRPC = nodeRPC
        self.env = env
        self.domain = domain
        self.proto = proto
        self.appSetting = appSetting
    }
}

public class UniPassConfig {
    public var nodeRPC: String
    public var chainType: ChainType
    public var env: Environment
    public var domain: String
    public var proto: String
    public var appSetting: AppSetting
    public init(nodeRPC: String, chainType: ChainType, env: Environment, domain: String, proto: String, appSetting: AppSetting) {
        self.nodeRPC = nodeRPC
        self.chainType = chainType
        self.env = env
        self.domain = domain
        self.proto = proto
        self.appSetting = appSetting
    }
}
