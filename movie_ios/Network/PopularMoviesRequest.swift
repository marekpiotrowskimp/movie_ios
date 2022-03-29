import Foundation

protocol Request {
    var urlRequest: String { get }
    func getURLRequest() -> URLRequest?
}

class PopularMoviesRequest: Request {
    private let movieUrl = "https://api.themoviedb.org/3/movie/popular?api_key=55957fcf3ba81b137f8fc01ac5a31fb5&language=en-US&page="
    let urlRequest: String
    let page: Int
    
    init(page: Int) {
        self.page = page
        self.urlRequest = "\(movieUrl)\(page)"
        print(urlRequest)
    }
    
    func getURLRequest() -> URLRequest? {
        try? URLRequest(url: urlRequest, method: .get, headers: nil)
    }
}
