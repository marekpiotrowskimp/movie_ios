import UIKit

class HomeCoorditator: Coordinating {
    
    // MARK: - HomeCoorditator properties
    
    private let factories: FactoriesCoordinatorProtocol
    private let factory: HomeFactoryProtocol
    private let dependencies: ApplicationDependencies
    lazy var rootViewController: UIViewController = {
        factory.buildHomeViewController(coordinating: self)
    }()
    
    // MARK: - Initialization
    
    init(factories: FactoriesCoordinatorProtocol, dependencies: ApplicationDependencies) {
        self.factories = factories
        self.factory = factories.buildHomeFactory()
        self.dependencies = dependencies
    }
    
    // MARK: - Coordinating
    
    func show(destination: CoordinatorDestination) {
        switch destination {
        case .movieDetails(let movieId):
            let viewController = factory.buildMovieDetailsViewController(movieId: movieId)
            viewController.modalPresentationStyle = .overFullScreen
            rootViewController.present(viewController, animated: true)
        case .home:
            break
        }
    }
}
