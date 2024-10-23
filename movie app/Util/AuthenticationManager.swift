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
    @Published var isRequired = false
    let repository: RepositoryProtocol

    init(repository: RepositoryProtocol = Repository()) {
        self.repository = repository
    }
    
    static let shared = AuthenticationManager()
    
    func authenticateUser(completion: @escaping (Bool) -> Void) {
        if repository.checkExistingUser() {
            let context = LAContext()
            var error: NSError?

            if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
                let reason = "Authenticate to access your movies"

                context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { success, authenticationError in
                    DispatchQueue.main.async {
                        completion(success)
                    }
                }
            } else {
                DispatchQueue.main.async {
                    completion(false)
                }
            }
        }
    }
}
