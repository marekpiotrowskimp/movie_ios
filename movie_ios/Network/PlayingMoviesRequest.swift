import Foundation

class PlayingMoviesRequest: Request {
    private let movieUrl = "https://api.themoviedb.org/3/movie/now_playing?language=en-US&page=undefined&api_key=55957fcf3ba81b137f8fc01ac5a31fb5"
    let urlRequest: String
    let page: Int
    
    init(page: Int) {
        self.page = page
        self.urlRequest = "\(movieUrl)"
    }
    
    func getURLRequest() -> URLRequest? {
        try? URLRequest(url: urlRequest, method: .get, headers: nil)
    }
}
