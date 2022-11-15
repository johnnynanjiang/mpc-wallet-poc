//
//  UniPassViewController.swift
//  UniPass_Swift
//
//  Created by leven on 2022/11/14.
//

import Foundation
class UniPassViewController: BasePageViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barStyle = .black
        self.addJavaScriptHandler(handlerName: "onConnectReady") { [weak self]arg in
            guard let self = self else { return }
            print(arg)
        }
    }
}
