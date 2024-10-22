import SwiftUI

struct MovieItemView: View {
    let movie: Movie
    let width = UIScreen.main.bounds.width / 2 - 30
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            AsyncImage(url: URL(string: movie.poster)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: width, height: width * 1.5)
            } placeholder: {
                ProgressView()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: width, height: width * 1.5)
            }
            
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.black.opacity(0.8),
                    Color.black.opacity(0.0)
                ]),
                startPoint: .bottom,
                endPoint: .top
            )
            .frame(width: width, height: width * 1.5)

            Text(movie.title)
                .foregroundStyle(.white)
                .font(.system(size: 15, weight: .bold))
                .multilineTextAlignment(.leading)
                .padding([.leading, .bottom], 10)
        }
        .cornerRadius(20)
        .frame(width: width, height: width * 1.5)
        .clipped()
    }
}

#Preview {
    MovieItemView(
        movie: Movie(
            title: "Captain Marvel",
            year: "2019",
            imdbID: "tt0145487",
            type: "movie",
            poster: "https://m.media-amazon.com/images/M/MV5BZDI1NGU2ODAtNzBiNy00MWY5LWIyMGEtZjUxZjUwZmZiNjBlXkEyXkFqcGc@._V1_SX300.jpg"
        )
    )
}
