import XCTest
import RxSwift
import RxBlocking
@testable import movie_ios

class HomeViewModelSpec: XCTestCase {
    var sut: HomeViewModelProtocol!
    var movieServicesMock: MovieServiceMock!
    var coordinatingMock: CoordinationgMock!
    
    override func setUp() {
        movieServicesMock = MovieServiceMock()
        coordinatingMock = CoordinationgMock()
        sut = HomeViewModel(movieService: movieServicesMock, coordinating: coordinatingMock)
    }

    override func tearDown() {
        sut = nil
        movieServicesMock = nil
        coordinatingMock = nil
    }

    func testshowMovieDetails() {
        let movieId = 1234
        sut.showMovieDetails(movieId: movieId)
        XCTAssertTrue(coordinatingMock.invokedShow)
        XCTAssertEqual(coordinatingMock.invokedShowCount, 1)
        guard let showDestination = coordinatingMock.invokedShowParameters?.0 else { return XCTFail() }
        if case let .movieDetails(movieIdShow) = showDestination {
            XCTAssertEqual(movieId, movieIdShow)
        } else {
            XCTFail()
        }
    }
    
    func testFetchMovies() {
        let title = "Matrix"
        let url = "https://api.themoviedb.org/3/movie/popular?api_key=55957fcf3ba81b137f8fc01ac5a31fb5&language=en-US&page=1"
        let movie = MovieHelper.getMovie()
        let movies = Movies(page: 1, movies: [movie], totalPages: 2, totalResults: 2)
        let result = ApiResult<Movies, ApiErrorMessage>(value: movies)
        movieServicesMock.stubbedFetchMoviesResult = Observable.just(result)
        let moviesResult = try? sut.getMovies().toBlocking(timeout: 1).first()
        XCTAssertTrue(movieServicesMock.invokedFetchMovies)
        XCTAssertEqual(movieServicesMock.invokedFetchMoviesCount, 1)
        XCTAssertEqual(movieServicesMock.invokedFetchMoviesParameters?.request.urlRequest, url)
        if case let .success(data) = moviesResult {
            let fetchedMovie = data.movies?.first
            XCTAssertNotNil(fetchedMovie)
            XCTAssertEqual(fetchedMovie!.title, title)
        } else {
            XCTFail()
        }
    }
    
    func testFetchNextMoviesPagination() {
        let title = "Matrix"
        let url = "https://api.themoviedb.org/3/movie/popular?api_key=55957fcf3ba81b137f8fc01ac5a31fb5&language=en-US&page=2"
        let movie = MovieHelper.getMovie()
        let movies = Movies(page: 1, movies: [movie], totalPages: 2, totalResults: 2)
        let result = ApiResult<Movies, ApiErrorMessage>(value: movies)
        movieServicesMock.stubbedFetchMoviesResult = Observable.just(result)
        let moviesResult = try? sut.getMovies().toBlocking(timeout: 1).first()
        XCTAssertTrue(movieServicesMock.invokedFetchMovies)
        XCTAssertEqual(movieServicesMock.invokedFetchMoviesCount, 1)
        sut.fetchNext()
        let _ = try? sut.getMovies().toBlocking(timeout: 1).first()
        XCTAssertEqual(movieServicesMock.invokedFetchMoviesCount, 2)
        XCTAssertEqual(movieServicesMock.invokedFetchMoviesParameters?.request.urlRequest, url)
        if case let .success(data) = moviesResult {
            let fetchedMovie = data.movies?.first
            XCTAssertNotNil(fetchedMovie)
            XCTAssertEqual(fetchedMovie!.title, title)
        } else {
            XCTFail()
        }
    }
    
    func testFetchPlayingMovies() {
        let title = "Matrix"
        let url = "https://api.themoviedb.org/3/movie/now_playing?language=en-US&page=undefined&api_key=55957fcf3ba81b137f8fc01ac5a31fb5"
        let movie = MovieHelper.getMovie()
        let movies = Movies(page: 1, movies: [movie], totalPages: 2, totalResults: 2)
        let result = ApiResult<Movies, ApiErrorMessage>(value: movies)
        movieServicesMock.stubbedFetchMoviesResult = Observable.just(result)
        let moviesResult = try? sut.getPlayingMovies().toBlocking(timeout: 1).first()
        XCTAssertTrue(movieServicesMock.invokedFetchMovies)
        XCTAssertEqual(movieServicesMock.invokedFetchMoviesCount, 1)
        XCTAssertEqual(movieServicesMock.invokedFetchMoviesParameters?.request.urlRequest, url)
        if case let .success(data) = moviesResult {
            let fetchedMovie = data.movies?.first
            XCTAssertNotNil(fetchedMovie)
            XCTAssertEqual(fetchedMovie!.title, title)
        } else {
            XCTFail()
        }
    }
}
