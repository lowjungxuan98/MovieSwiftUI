//
//  MovieListViewModel.swift
//  movie app
//
//  Created by Low Jung Xuan on 22/10/2024.
//

import Foundation
import Combine

class MovieListViewModel: ObservableObject {
    @Published var movies: [Movie] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    @Published var selectedMovie: Movie?
    
    private var cancellables = Set<AnyCancellable>()
    private let repository: MovieRepositoryProtocol
    
    init(repository: MovieRepositoryProtocol = MovieRepository()) {
        self.repository = repository
    }
    
    func fetchMovies(searchQuery: String) {
        isLoading = true
        errorMessage = nil
        repository.fetchMovies(searchQuery: searchQuery)
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
}
