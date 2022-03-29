import Foundation
import Alamofire
import RxAlamofire
import RxSwift

class MovieServiceImpl: MovieService {
    
    // MARK: - MovieService
    
    func fetchMovies<T: Decodable & Encodable>(request: Request) ->  Observable<ApiResult<T, ApiErrorMessage>> {
        guard let urlRequest = request.getURLRequest() else { return Observable.empty() }
        return RxAlamofire.request(urlRequest).responseData().expectingObject(ofType: T.self)
    }
}
