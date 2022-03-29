import Foundation
import RxSwift

class MoviePlayingCellViewModel {
    private let posterPathSubject = BehaviorSubject<String?>(value: nil)
    let movie: Movie
    lazy var posterPathObservable: Observable<String?> = {
        posterPathSubject
    }()
    
    init(movie: Movie) {
        self.movie = movie
        posterPathSubject.onNext(movie.posterPath)
    }
}

