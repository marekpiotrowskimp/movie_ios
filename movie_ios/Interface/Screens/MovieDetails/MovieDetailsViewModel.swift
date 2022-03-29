import RxSwift

protocol MovieDetailsViewModelProtocol {
    func getMovieDetails()
    var titleObservable: Observable<String?> { get }
    var releaseDateAndRunTimeObservable: Observable<String?> { get }
    var posterPathObservable: Observable<String?> { get }
    var descriptionObservable: Observable<String?> { get }
    var genreObservable: Observable<[Genre]> { get }
}


class MovieDetailsViewModel: MovieDetailsViewModelProtocol {
    
    // MARK: - MovieDetailsViewModel properties
    
    private let disposeBag = DisposeBag()
    private let titleSubject = BehaviorSubject<String?>(value: nil)
    private let releaseDateAndRunTimeSubject = BehaviorSubject<String?>(value: nil)
    private let descriptionSubject = BehaviorSubject<String?>(value: nil)
    private let posterPathSubject = BehaviorSubject<String?>(value: nil)
    private let genreSubject = BehaviorSubject<[Genre]>(value: [])
    
    private let movieService: MovieService
    private let movieId: Int
    
    // MARK: - Observables
    
    lazy var titleObservable: Observable<String?> = {
       titleSubject
    }()
    
    lazy var releaseDateAndRunTimeObservable: Observable<String?> = {
        releaseDateAndRunTimeSubject
    }()
    
    lazy var descriptionObservable: Observable<String?> = {
        descriptionSubject
    }()
    
    lazy var posterPathObservable: Observable<String?> = {
        posterPathSubject
    }()
    
    lazy var genreObservable: Observable<[Genre]> = {
        genreSubject
    }()
    
    // MARK: - Initialization
    
    init(movieService: MovieService, movieId: Int) {
        self.movieService = movieService
        self.movieId = movieId
    }
    
    // MARK: - MovieDetailsViewModelProtocol
    
    func getMovieDetails() {
        fetchDatails()
            .map { result -> MovieDetailsDTO? in
                switch result {
                    case .success(let movieDetailsDTO):
                    return movieDetailsDTO
                    case .failure(_):
                    return nil
                }
            }.subscribe(onNext: { [weak self] movieDetails in
                guard let self = self, let movieDetails = movieDetails else { return }
                self.setupData(movieDetails: movieDetails)
            }).disposed(by: disposeBag)
    }
    
    // MARK: - private methods
    
    private func fetchDatails() -> Observable<ApiResult<MovieDetailsDTO, ApiErrorMessage>> {
        self.movieService.fetchMovies(request: MovieDetailsRequest(movieId: movieId))
    }
    
    private func setupData(movieDetails: MovieDetailsDTO) {
        posterPathSubject.onNext(movieDetails.posterPath)
        titleSubject.onNext(movieDetails.title)
        releaseDateAndRunTimeSubject.onNext("\(movieDetails.releaseDate ?? "") - \(movieDetails.runtime?.formatMinutesToHoursMinutes() ?? "")")
        descriptionSubject.onNext(movieDetails.overview)
        genreSubject.onNext(movieDetails.genres ?? [])
    }
    
}
