//
//  AuthenticationManager.swift
//  movie app
//
//  Created by Your Name on 23/10/2024.
//

import Foundation
import LocalAuthentication
import Combine

class AuthenticationManager: ObservableObject {
    @Published var isAuthenticated = true
    @Published var biometricEnabled = false // Track if the user has enabled biometrics

    func authenticateUser() {
        let context = LAContext()
        var error: NSError?

        if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
            let reason = "Authenticate to access your movies"

            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { success, authenticationError in
                DispatchQueue.main.async {
                    if success {
                        self.isAuthenticated = true
                    } else {
                        self.isAuthenticated = false
                        // Optionally, handle specific errors here
                    }
                }
            }
        } else {
            DispatchQueue.main.async {
                self.isAuthenticated = false
                // Optionally, handle cases where authentication is not available
            }
        }
    }
}
