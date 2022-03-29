import Foundation
import RxSwift

class MovieCellViewModel {
    
    // MARK: - MovieCellViewModel properties
    
    private let titleSubject = BehaviorSubject<String?>(value: nil)
    private let releaseDateSubject = BehaviorSubject<String?>(value: nil)
    private let durationSubject = BehaviorSubject<String?>(value: nil)
    private let voteAverageSubject = BehaviorSubject<Double?>(value: nil)
    private let posterPathSubject = BehaviorSubject<String?>(value: nil)
    let movie: Movie
    
    // MARK: - Observables
    
    lazy var titleObservable: Observable<String?> = {
       titleSubject
    }()
    
    lazy var releaseDateObservable: Observable<String?> = {
        releaseDateSubject
    }()
    
    lazy var durationObservable: Observable<String?> = {
        durationSubject
    }()
    
    lazy var voteAverageObservable: Observable<Double?> = {
        voteAverageSubject
    }()
    
    lazy var posterPathObservable: Observable<String?> = {
        posterPathSubject
    }()
    
    // MARK: - Initialization
    
    init(movie: Movie) {
        self.movie = movie
        titleSubject.onNext(movie.title)
        releaseDateSubject.onNext(movie.releaseDate)
        durationSubject.onNext("1h 33m")
        voteAverageSubject.onNext(movie.voteAverage)
        posterPathSubject.onNext(movie.posterPath)
    }
}
