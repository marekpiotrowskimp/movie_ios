import Foundation
import RxSwift

protocol MovieService {
    func fetchMovies<T: Decodable & Encodable>(request: Request) ->  Observable<ApiResult<T, ApiErrorMessage>>
}

