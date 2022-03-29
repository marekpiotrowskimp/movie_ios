@testable import movie_ios

class MovieHelper {
    static func getMovie() -> Movie {
        Movie(adult: true, backdropPath: "backdropPath", genreIDS: [1,2], id: 1234, originalLanguage: "en", originalTitle: "Matrix", overview: "overview", popularity: 1, posterPath: "posterPath", releaseDate: "01.01.2022", title: "Matrix", video: true, voteAverage: 50, voteCount: 1)
    }
    
    static func getMovieDetails() -> MovieDetailsDTO {
        MovieDetailsDTO(adult: true, backdropPath: "backdropPath", belongsToCollection: nil, budget: 123, genres: [Genre(id: 1, name: "SF")], homepage: "homepage", id: 1, imdbID: "imdbID", originalLanguage: "en", originalTitle: "Matrix", overview: "overview", popularity: 1, posterPath: "posterPath", productionCompanies: nil, productionCountries: nil, releaseDate: "01.01.2022", revenue: 1, runtime: 1, spokenLanguages: nil, status: "status", tagline: "tagline", title: "Matrix", video: true, voteAverage: 5, voteCount: 1)
    }
}
