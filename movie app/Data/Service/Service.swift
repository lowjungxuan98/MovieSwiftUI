//
//  Service.swift
//  movie app
//
//  Created by Low Jung Xuan on 23/10/2024.
//

import Foundation
import Combine
import FirebaseAuth

protocol ServiceProtocol {
    func fetchMovies(searchQuery: String) -> AnyPublisher<[Movie], Error>
    func fetchMovieDetail(imdbID: String) -> AnyPublisher<MovieDetail, Error>
    func login(username: String, password: String) -> AnyPublisher<AppUser, Error>
    func signup(username: String, password: String) -> AnyPublisher<AppUser, Error>
    func logout() -> AnyPublisher<Void, Never>
}

class Service: ServiceProtocol {
    private let apiKey = "6fc87060"
    private let baseURL = "http://www.omdbapi.com/"

    func fetchMovies(searchQuery: String) -> AnyPublisher<[Movie], Error> {
          guard let url = URL(string: "\(baseURL)?apikey=\(apiKey)&s=\(searchQuery)&type=movie") else {
              return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
          }

          return URLSession.shared.dataTaskPublisher(for: url)
              .map(\.data)
              .decode(type: MovieList.self, decoder: JSONDecoder())
              .map { $0.movies }
              .eraseToAnyPublisher()
      }

      func fetchMovieDetail(imdbID: String) -> AnyPublisher<MovieDetail, Error> {
          guard let url = URL(string: "\(baseURL)?apikey=\(apiKey)&i=\(imdbID)") else {
              return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
          }

          return URLSession.shared.dataTaskPublisher(for: url)
              .map(\.data)
              .decode(type: MovieDetail.self, decoder: JSONDecoder())
              .eraseToAnyPublisher()
      }
    
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
