//
//  Storage.swift
//  UniWallet
//
//  Created by leven on 2022/11/6.
//

import Foundation
let upAccountKey = "unipass_user_accounts"

class Storage {
    
    class func saveUpAccount(account: UpAccount) {
        UserDefaults.standard.set(account.toJsonString(), forKey: upAccountKey)
    }
    
    class func getUpAccount() -> UpAccount? {
        if let jsonString = UserDefaults.standard.object(forKey: upAccountKey) as? String, let data = jsonString.data(using: .utf8),  let obj = try? JSONSerialization.jsonObject(with: data, options: [.fragmentsAllowed]), let map = obj as? [String: Any] {
            let account = UpAccount(address: map["address"] as? String ?? "", email: map["email"] as? String ?? "", newborn:  map["newborn"] as? Int ?? 0)
            return account
        }
        return nil
    }
    
    class func removeUpAccount() {
        UserDefaults.standard.removeObject(forKey: upAccountKey)
    }
    
}
