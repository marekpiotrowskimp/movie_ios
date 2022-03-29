
protocol ApplicationDependencies {
    var movieService: MovieService { get }
}

final class DependencyContainer: ApplicationDependencies {
    
    // MARK: - ApplicationDependencies
    
    lazy var movieService: MovieService = {
       MovieServiceImpl()
    }()
    
}
