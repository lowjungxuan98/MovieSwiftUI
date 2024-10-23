//
//  MovieListViewModel.swift
//  movie app
//
//  Created by Low Jung Xuan on 22/10/2024.
//

import Foundation
import Combine

class MovieListViewModel: BaseViewModel {
    @Published var movies: [Movie] = []
    @Published var selectedMovie: Movie?
    @Published var searchText = "Marvel"

    func onStart() {
        fetchMovies()
    }
    
    func fetchMovies() {
        isLoading = true
        errorMessage = nil
        repository.fetchMovies(searchQuery: searchText)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                case .finished:
                    break
                }
            }, receiveValue: { movies in
                self.movies = movies
            })
            .store(in: &cancellables)
    }
    
    func logout() {
        isLoading = true
        errorMessage = nil
        repository.logout()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                case .finished:
                    break
                }
            }, receiveValue: { _ in
            })
            .store(in: &cancellables)
    }
}
