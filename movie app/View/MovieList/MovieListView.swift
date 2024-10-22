//
//  MovieListView.swift
//  movie app
//
//  Created by Low Jung Xuan on 22/10/2024.
//

import SwiftUI

struct MovieListView: View {
    @StateObject private var viewModel = MovieListViewModel()
    @State private var searchText = "Marvel"
    @State private var showingSheet = false

    let textFieldHeight: CGFloat = 50
    var body: some View {
            VStack {
                TextField(
                    "Search...",
                    text: $searchText,
                    onCommit: {
                        viewModel.fetchMovies(searchQuery: searchText)
                    }
                )
                .padding(.horizontal)
                .frame(height: textFieldHeight)
                
                .font(
                    .system(
                        size: 16,
                        weight: .semibold,
                        design: .default
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: textFieldHeight / 2)
                        .stroke(Color.blue, lineWidth: 4)
                )
                .cornerRadius(textFieldHeight / 2)
                
                if viewModel.isLoading {
                    ProgressView("Loading movies...")
                } else if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage).foregroundColor(.red)
                } else {
                    ScrollView {
                        LazyVGrid(
                            columns: [
                                GridItem(.flexible()),
                                GridItem(.flexible())
                            ],
                            spacing: 20
                        ) {
                            ForEach(viewModel.movies, id: \.title) { movie in
                                MovieItemView(movie: movie)
                                    .onTapGesture {
                                        viewModel.selectedMovie = movie
                                        showingSheet.toggle()
                                    }
                            }
                        }
                    }
                    .scrollIndicators(.hidden)
                }
            }
            .padding([.horizontal])
            .onAppear {
                viewModel.fetchMovies(searchQuery: searchText)
            }
            .fullScreenCover(isPresented: $showingSheet, content: {
                if let movie = viewModel.selectedMovie {
                    MovieDetailView(movie: movie)
                }
            })
    }
}

#Preview {
    MovieListView()
}
