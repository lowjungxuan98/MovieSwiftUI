//
//  LoginViewModel.swift
//  movie app
//
//  Created by Low Jung Xuan on 23/10/2024.
//

import Foundation
import SwiftUI

class LoginViewModel: BaseViewModel {
    @Published var username = ""
    @Published var password = ""
    @Published var showingErrorAlert = false
    @Published var success = false
    
    func login() {
        isLoading = true
        errorMessage = nil
        
        repository.login(username: username, password: password)
            .receive(on: DispatchQueue.main)
            .sink { [self] completion in
                self.isLoading = false
                switch completion {
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    self.showingErrorAlert = true
                case .finished:
                    break
                }
            } receiveValue: { [self] user in
                self.showingErrorAlert = false
                self.success = true
            }
            .store(in: &cancellables)
    }
}
