import Foundation

final class MovieImageEndpoint {
    private let posterPath: String?
    
    lazy var urlPath = "https://image.tmdb.org/t/p/w500/\(posterPath ?? "")"
    
    init(posterPath: String?) {
        self.posterPath = posterPath
    }
}
