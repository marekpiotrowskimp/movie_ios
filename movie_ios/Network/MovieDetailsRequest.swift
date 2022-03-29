import Foundation

class MovieDetailsRequest: Request {
    lazy var urlRequest = "https://api.themoviedb.org/3/movie/\(movieId)?api_key=55957fcf3ba81b137f8fc01ac5a31fb5&language=en-US"
    let movieId: Int
    
    init(movieId: Int) {
        self.movieId = movieId
    }
    
    func getURLRequest() -> URLRequest? {
        try? URLRequest(url: urlRequest, method: .get, headers: nil)
    }
}
