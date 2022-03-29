import UIKit

protocol HomeFactoryProtocol {
    func buildHomeViewController(coordinating: Coordinating) -> UIViewController
    func buildMovieDetailsViewController(movieId: Int) -> UIViewController
}

class HomeFactory: HomeFactoryProtocol {
    
    // MARK: - HomeFactory properties
    
    private let dependencies: ApplicationDependencies
    
    // MARK: - Initialization
    
    init(dependencies: ApplicationDependencies) {
        self.dependencies = dependencies
    }
    
    // MARK: - HomeFactoryProtocol
    
    func buildHomeViewController(coordinating: Coordinating) -> UIViewController {
        let viewModel = HomeViewModel(movieService: dependencies.movieService, coordinating: coordinating)
        return HomeViewController(viewModel: viewModel)
    }
    
    func buildMovieDetailsViewController(movieId: Int) -> UIViewController {
        let viewModel = MovieDetailsViewModel(movieService: dependencies.movieService, movieId: movieId)
        return MovieDetailsViewController(viewModel: viewModel)
    }
    
    
}
