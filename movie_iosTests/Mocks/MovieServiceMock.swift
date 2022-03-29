import XCTest
import RxSwift
@testable import movie_ios

class MovieServiceMock: MovieService {

    var invokedFetchMovies = false
    var invokedFetchMoviesCount = 0
    var invokedFetchMoviesParameters: (request: Request, Void)?
    var invokedFetchMoviesParametersList = [(request: Request, Void)]()
    var stubbedFetchMoviesResult: Observable<ApiResult<Movies, ApiErrorMessage>>? = nil
    var stubbedFetchMoviesDetailsResult: Observable<ApiResult<MovieDetailsDTO, ApiErrorMessage>>? = nil

    func fetchMovies<T: Decodable & Encodable>(request: Request) ->  Observable<ApiResult<T, ApiErrorMessage>> {
        invokedFetchMovies = true
        invokedFetchMoviesCount += 1
        invokedFetchMoviesParameters = (request, ())
        invokedFetchMoviesParametersList.append((request, ()))
        return stubbedFetchMoviesResult != nil ?  stubbedFetchMoviesResult as! Observable<ApiResult<T, ApiErrorMessage>> : stubbedFetchMoviesDetailsResult as! Observable<ApiResult<T, ApiErrorMessage>>
    }
}
