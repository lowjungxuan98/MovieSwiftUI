//
//  MovieDetailView.swift
//  movie app
//
//  Created by Low Jung Xuan on 22/10/2024.
//

import SwiftUI

struct MovieDetailView: View {
    let movie: Movie
    
    @StateObject private var viewModel = MovieDetailViewModel()
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(alignment: .leading) {
            if viewModel.isLoading {
                ProgressView("Loading movie details...")
            } else if let errorMessage = viewModel.errorMessage {
                Text(errorMessage).foregroundColor(.red)
                PrimaryButton(title: "Back") {
                    dismiss()
                }
            } else if let movieDetail = viewModel.movieDetail {
                GeometryReader { geometry in
                    ScrollView {
                        ZStack(alignment: .top) {
                            AsyncImage(url: URL(string: movieDetail.poster)) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(height: 190)
                                    .blur(radius: 10)
                                    .ignoresSafeArea()
                            } placeholder: {
                                Color.gray.opacity(0.5)
                            }
                            
                            Path { path in
                                path.move(to: CGPoint(x:0, y: 170))
                                path.addLine(to: CGPoint(x: geometry.size.width, y: 300))
                                path.addLine(to: CGPoint(x: geometry.size.width, y: geometry.size.height))
                                path.addLine(to: CGPoint(x: 0, y: geometry.size.height))
                                path.closeSubpath()
                            }
                            .fill(Color.white)
                            .ignoresSafeArea(edges: .bottom)
                            
                            VStack(alignment: .leading, spacing: 10) {
                                HStack {
                                    Spacer()
                                    Button(action: {
                                        dismiss()
                                    }) {
                                        Image("close")
                                            .resizable()
                                            .frame(width: 36, height: 36)
                                            .foregroundColor(.blue)
                                    }
                                    .padding(.top)
                                }
                                
                                AsyncImage(url: URL(string: movieDetail.poster)) { image in
                                    image
                                        .resizable()
                                        .scaledToFit()
                                        .cornerRadius(10)
                                        .frame(width: 180, height: 250)
                                } placeholder: {
                                    ProgressView()
                                        .frame(width: 180, height: 250)
                                }
                                
                                HStack(alignment: .bottom) {
                                    HStack(spacing: 2) {
                                        ForEach(0..<5) { star in
                                            Image(systemName: star < Int((movieDetail.imdbRating as NSString).doubleValue / 2) ? "star.fill" : "star")
                                                .foregroundColor(.blue)
                                        }
                                    }
                                    
                                    Text("\(movieDetail.imdbRating) / 10")
                                        .font(.system(size: 20, weight: .bold))
                                        .foregroundColor(.blue)
                                    
                                    Text("\(movieDetail.imdbVotes) Ratings")
                                        .font(.footnote)
                                        .foregroundColor(.gray)
                                }
                                
                                Text("\(movieDetail.title) (\(movieDetail.year))")
                                    .font(.title.bold())
                                
                                // Genre
                                Text(movieDetail.genre)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                
                                // Plot Summary
                                Text("Plot Summary")
                                    .font(.title3.bold())
                                    .padding(.top)
                                
                                Text(movieDetail.plot)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                    .padding(.bottom)
                                
                                Text("Other Ratings")
                                    .font(.title3.bold())
                                
                                ScrollView(.horizontal) {
                                    LazyHStack(spacing: 10) {
                                        ForEach(movieDetail.ratings, id: \.source) { rating in
                                            VStack {
                                                Text(rating.source)
                                                    .font(.system(size: 15))
                                                    .frame(maxWidth: .infinity, alignment: .leading)
                                                    .padding([.bottom, .leading], 10)
                                                
                                                Text(rating.value)
                                                    .font(.system(size: 13, weight: .bold))
                                                    .frame(maxWidth: .infinity, alignment: .trailing)
                                                    .foregroundColor(.blue)
                                                    .padding( .trailing, 10)
                                            }
                                            .frame(width: 210, height: 60)
                                            .background(Color.white)
                                            .cornerRadius(10)
                                            .shadow(color: .blue.opacity(0.2), radius: 3, y: 3)
                                            .padding(.horizontal, 5)
                                        }
                                    }
                                }
                                .scrollIndicators(.hidden)
                                .frame(height: 80)
                                
                                Spacer()
                            }
                            .padding(.horizontal)
                        }
                    }
                    .scrollIndicators(.hidden)
                }
            }
        }
        .onAppear {
            viewModel.fetchMovieDetails(imdbID: movie.imdbID)
        }
    }
}

#Preview {
    MovieDetailView(
        movie: Movie(
            title: "Captain Marvel",
            year: "2019",
            imdbID: "tt4154664",
            type: "movie",
            poster: "https://m.media-amazon.com/images/M/MV5BZDI1NGU2ODAtNzBiNy00MWY5LWIyMGEtZjUxZjUwZmZiNjBlXkEyXkFqcGc@._V1_SX300.jpg"
        )
    )
}

