//
//  Config.swift
//  UniWallet
//
//  Created by leven on 2022/11/6.
//

import Foundation
public struct RpcUrl {
    let polygonMainnet: String
    let bscMainnet: String
    let rangersMainnet: String
    let polygonMumbai: String
    let bscTestnet: String
    let rangersRobin: String
}

let rpcUrl: RpcUrl = RpcUrl(polygonMainnet: "https://node.wallet.unipass.id/polygon-mainnet",
                            bscMainnet: "https://node.wallet.unipass.id/bsc-mainnet",
                            rangersMainnet: "https://node.wallet.unipass.id/rangers-mainnet",
                            polygonMumbai: "https://node.wallet.unipass.id/polygon-mumbai",
                            bscTestnet: "https://node.wallet.unipass.id/bsc-testnet",
                            rangersRobin: "https://node.wallet.unipass.id/rangers-robin")

public func getRpcUrl(env: Environment, chainType: ChainType) -> String {
    if env == .testnet {
        switch chainType {
        case .polygon:
            return rpcUrl.polygonMumbai
        case .bsc:
            return rpcUrl.bscTestnet
        case .rangers:
            return rpcUrl.rangersRobin
        }
    } else {
        switch chainType {
        case .polygon:
            return rpcUrl.polygonMainnet
        case .bsc:
            return rpcUrl.bscMainnet
        case .rangers:
            return rpcUrl.rangersMainnet
        }
    }
}

let upDomain = "wallet.unipass.id"


public func getWalletUrl(messageType: MessageType, domain: String?, proto: String?) -> String {
    let proto = proto ?? "https"
    let domain = domain ?? upDomain
    
    switch messageType {
    case .upConnect:
        return proto + "://" + domain + "/connect"
    case .upSignMessage:
        return proto + "://" + domain + "/sign-message"
    case .upSendTransaction:
        return proto + "://" + domain + "/send-transaction"
    case .upReady:
        return proto + "://" + domain + "/connect/loading"
    }
}
