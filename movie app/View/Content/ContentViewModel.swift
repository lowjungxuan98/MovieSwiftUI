//
//  ContentViewModel.swift
//  movie app
//
//  Created by Low Jung Xuan on 22/10/2024.
//

import Foundation
import Combine

class ContentViewModel: BaseViewModel {
    @Published var isUserLoggedIn: Bool = false

    init() {
        super.init()
        isUserLoggedIn = self.repository.checkExistingUser()
    }
}
