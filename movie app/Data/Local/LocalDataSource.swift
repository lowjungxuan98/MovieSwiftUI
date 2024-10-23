//
//  LocalDataSource.swift
//  movie app
//
//  Created by Low Jung Xuan on 23/10/2024.
//

import Foundation
import Combine
import RealmSwift

protocol LocalDataSourceProtocol {
    func saveMovies(_ movies: [Movie])
    func fetchMovies(searchQuery: String) -> AnyPublisher<[Movie], Error>
    func saveCurrentUser(_ user: AppUser)
    func clearCurrentUser()
    var currentUser: AppUser? { get }
}

class LocalDataSource: LocalDataSourceProtocol {
    @Published var currentUser: AppUser?
    
    private let userDefaults = UserDefaults.standard
    private let currentUserKey = "currentUser"
    
    init() {
        if let savedUserData = userDefaults.data(forKey: currentUserKey),
           let savedUser = try? JSONDecoder().decode(AppUser.self, from: savedUserData) {
            self.currentUser = savedUser
        }
    }
    
    func saveMovies(_ movies: [Movie]) {
        DispatchQueue(label: "RealmWriteQueue").async {
            autoreleasepool {
                do {
                    let realm = try Realm()
                    let movieEntities = movies.map { MovieEntity(movie: $0) }
                    try realm.write {
                        realm.add(movieEntities, update: .modified)
                    }
                } catch {
                    print("Error saving movies to Realm: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func fetchMovies(searchQuery: String) -> AnyPublisher<[Movie], Error> {
        Future<[Movie], Error> { promise in
            DispatchQueue(label: "RealmReadQueue").async {
                autoreleasepool {
                    do {
                        let realm = try Realm()
                        var movieEntities = realm.objects(MovieEntity.self)
                        if !searchQuery.isEmpty {
                            movieEntities = movieEntities.filter("title CONTAINS[c] %@", searchQuery)
                        }
                        let movies = movieEntities.map { Movie(entity: $0) }
                        promise(.success(Array(movies)))
                    } catch {
                        promise(.failure(error))
                    }
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func saveCurrentUser(_ user: AppUser) {
        self.currentUser = user
        if let userData = try? JSONEncoder().encode(user) {
            userDefaults.set(userData, forKey: currentUserKey)
        }
    }
    
    func clearCurrentUser() {
        self.currentUser = nil
        userDefaults.removeObject(forKey: currentUserKey)
        AuthenticationManager.shared.isRequired = false
    }
}
