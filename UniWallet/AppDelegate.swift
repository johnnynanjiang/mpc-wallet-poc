//
//  AppDelegate.swift
//  UniWallet
//
//  Created by leven on 2022/11/15.
//

import UIKit
import UniPass_Swift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var splashV: UIView?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = UINavigationController(rootViewController: UniPassController.getUniPassPage())
        splashV = UIScreen.main.snapshotView(afterScreenUpdates: true)
        splashV?.frame = window?.bounds ?? CGRect.zero
        window?.makeKeyAndVisible()
        if let splashV = splashV {
            window?.addSubview(splashV)
        }
        NotificationCenter.default.addObserver(forName: .init(rawValue: UniPassController.UniPassDidCreateNotification), object: nil, queue: nil) { [weak self]_ in
            guard let self = self else { return }
            UIView.animate(withDuration: 0.2, delay: 0.5, options: .curveEaseInOut) {
                self.splashV?.alpha = 0
            } completion: { _ in
                self.splashV?.removeFromSuperview()
            }
        }
        return true
    }
    
}

