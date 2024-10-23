//
//  ContentViewModel.swift
//  movie app
//
//  Created by Low Jung Xuan on 22/10/2024.
//

import Combine
import SwiftUI

class ContentViewModel: BaseViewModel {
    @Published var isUserLoggedIn: Bool = false
    
    init() {
        super.init()
        NotificationCenter.default.addObserver(self, selector: #selector(handleLoginStatusChanged(_:)), name: .userLoginStatusChanged, object: nil)
        NotificationCenter.default.post(name: .userLoginStatusChanged, object: nil, userInfo: ["isLoggedIn": self.repository.checkExistingUser()])
    }
    
    @objc private func handleLoginStatusChanged(_ notification: Notification) {
        if let isLoggedIn = notification.userInfo?["isLoggedIn"] as? Bool {
            self.isUserLoggedIn = isLoggedIn
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .userLoginStatusChanged, object: nil)
    }
}

extension Notification.Name {
    static let userLoginStatusChanged = Notification.Name("userLoginStatusChanged")
}
