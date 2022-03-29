import Foundation
import RxSwift
import RxRelay

protocol HomeViewModelProtocol {
    func getMovies() -> Observable<ApiResult<Movies, ApiErrorMessage>>
    func getPlayingMovies() -> Observable<ApiResult<Movies, ApiErrorMessage>>
    func fetchNext()
    func showMovieDetails(movieId: Int)
}

class HomeViewModel: HomeViewModelProtocol {
    
    // MARK: - HomeViewModel properties
    
    private let disposeBag = DisposeBag()
    private let movieService: MovieService
    private let fetchRelay = BehaviorRelay(value: 1)
    private let coordinating: Coordinating
    
    // MARK: - Initialization
    
    init(movieService: MovieService, coordinating: Coordinating) {
        self.movieService = movieService
        self.coordinating = coordinating
    }
    
    // MARK: - HomeViewModelProtocol
    
    func getPlayingMovies() -> Observable<ApiResult<Movies, ApiErrorMessage>> {
        self.movieService.fetchMovies(request: PlayingMoviesRequest(page: 0))
    }
    
    func getMovies() -> Observable<ApiResult<Movies, ApiErrorMessage>> {
        fetchRelay.flatMapLatest { [weak self] page -> Observable<ApiResult<Movies, ApiErrorMessage>> in
            guard let self = self else { return Observable.empty() }
            return self.movieService.fetchMovies(request: PopularMoviesRequest(page: page))
        }
    }
    
    func fetchNext() {
        fetchRelay.accept(fetchRelay.value + 1)
    }
    
    func showMovieDetails(movieId: Int) {
        coordinating.show(destination: .movieDetails(movieId))
    }
}
