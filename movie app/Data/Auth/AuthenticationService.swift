//
//  AuthenticationService.swift
//  movie app
//
//  Created by Low Jung Xuan on 23/10/2024.
//

import Foundation
import Combine
import FirebaseAuth

protocol AuthenticationServiceProtocol {
    func login(username: String, password: String) -> AnyPublisher<AppUser, Error>
    func signup(username: String, password: String) -> AnyPublisher<AppUser, Error>
    func logout() -> AnyPublisher<Void, Never>
}

class AuthenticationService: AuthenticationServiceProtocol {

    func login(username: String, password: String) -> AnyPublisher<AppUser, Error> {
        return Future<AppUser, Error> { promise in
            Auth.auth().signIn(withEmail: username, password: password) { result, error in
                if let error = error {
                    promise(.failure(error))
                } else if let user = result?.user {
                    let appUser = AppUser(uid: user.uid, email: user.email)
                    promise(.success(appUser))
                } else {
                    let error = NSError(domain: "LoginError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unknown login error"])
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }

    func signup(username: String, password: String) -> AnyPublisher<AppUser, Error> {
        return Future<AppUser, Error> { promise in
            Auth.auth().createUser(withEmail: username, password: password) { result, error in
                if let error = error {
                    promise(.failure(error))
                } else if let user = result?.user {
                    let appUser = AppUser(uid: user.uid, email: user.email)
                    promise(.success(appUser))
                } else {
                    let error = NSError(domain: "SignupError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unknown signup error"])
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }

    func logout() -> AnyPublisher<Void, Never> {
        return Future<Void, Never> { promise in
            do {
                try Auth.auth().signOut()
                promise(.success(()))
            } catch {
                promise(.success(()))
            }
        }
        .eraseToAnyPublisher()
    }
}
