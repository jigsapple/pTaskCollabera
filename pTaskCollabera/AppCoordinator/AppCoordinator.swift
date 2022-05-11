//
//  AppCoordinator.swift
//  pTaskCollabera
//
//  Created by Jignesh on 11/05/22.
//

import UIKit

class AppCoordinator {
    
    private let windows: UIWindow
    
    init(_window: UIWindow) {
        self.windows = _window
    }
    
    func start() {
        let loginVC = LoginViewController()
        let navigationController = UINavigationController(rootViewController: loginVC)
        self.windows.rootViewController = navigationController
        self.windows.makeKeyAndVisible()
    }
}
