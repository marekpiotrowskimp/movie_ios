import XCTest
import RxSwift
import RxBlocking
@testable import movie_ios

class MovieDetailsViewModelSpec: XCTestCase {
    var sut: MovieDetailsViewModelProtocol!
    var movieServicesMock: MovieServiceMock!
    let movieId = 1234
    
    override func setUp() {
        movieServicesMock = MovieServiceMock()
        sut = MovieDetailsViewModel(movieService: movieServicesMock, movieId: movieId)
    }

    override func tearDown() {
        sut = nil
        movieServicesMock = nil
    }

    func testFetchMovieDetails() {
        let title = "Matrix"
        let posterPath = "posterPath"
        let description = "overview"
        let releaseDateAndRunTime = "01.01.2022 - 0 Hours, 1 Minutes"
        let genre = [Genre(id: 1, name: "SF")]
        let url = "https://api.themoviedb.org/3/movie/1234?api_key=55957fcf3ba81b137f8fc01ac5a31fb5&language=en-US"
        let movieDetail = MovieHelper.getMovieDetails()
        let result = ApiResult<MovieDetailsDTO, ApiErrorMessage>(value: movieDetail)
        movieServicesMock.stubbedFetchMoviesDetailsResult = Observable.just(result)
        sut.getMovieDetails()
        let titleResult = try? sut.titleObservable.toBlocking(timeout: 1).first()
        let releaseDateAndRunTimeResult = try? sut.releaseDateAndRunTimeObservable.toBlocking(timeout: 1).first()
        let descriptionResult = try? sut.descriptionObservable.toBlocking(timeout: 1).first()
        let posterPathResult = try? sut.posterPathObservable.toBlocking(timeout: 1).first()
        let genrePathResult = try? sut.genreObservable.toBlocking(timeout: 1).first()
        
        XCTAssertEqual(titleResult, title)
        XCTAssertEqual(releaseDateAndRunTimeResult, releaseDateAndRunTime)
        XCTAssertEqual(descriptionResult, description)
        XCTAssertEqual(posterPathResult, posterPath)
        XCTAssertEqual(genrePathResult, genre)
        
        XCTAssertTrue(movieServicesMock.invokedFetchMovies)
        XCTAssertEqual(movieServicesMock.invokedFetchMoviesCount, 1)
        XCTAssertEqual(movieServicesMock.invokedFetchMoviesParameters?.request.urlRequest, url)
    }
}
