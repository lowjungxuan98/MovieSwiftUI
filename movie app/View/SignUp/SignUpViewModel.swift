//
//  SignUpViewModel.swift
//  movie app
//
//  Created by Low Jung Xuan on 23/10/2024.
//

import Foundation

class SignUpViewModel: BaseViewModel {
    @Published var username = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    @Published var showingErrorAlert = false
    @Published var success = false

    func signUp() {
        guard !username.isEmpty, !password.isEmpty, !confirmPassword.isEmpty else {
            errorMessage = "Please fill in all fields."
            showingErrorAlert = true
            return
        }
        
        guard password == confirmPassword else {
            errorMessage = "Passwords do not match."
            showingErrorAlert = true
            return
        }

        isLoading = true
        errorMessage = nil

        repository.signup(username: username, password: password)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .failure(let error):
                    self?.success = false
                    self?.errorMessage = error.localizedDescription
                    self?.showingErrorAlert = true
                case .finished:
                    break
                }
            } receiveValue: { [weak self] user in
                self?.success = true
            }
            .store(in: &cancellables)
    }
}
