protocol FactoriesCoordinatorProtocol {
    func buildHomeFactory() -> HomeFactoryProtocol
}

final class FactoriesCoordinator: FactoriesCoordinatorProtocol {
    
    // MARK: - FactoriesCoordinator properties
    
    private let dependencies: ApplicationDependencies
    
    // MARK: - Initialization
    
    init(dependencies: ApplicationDependencies) {
        self.dependencies = dependencies
    }
    
    // MARK: - FactoriesCoordinatorProtocol
    
    func buildHomeFactory() -> HomeFactoryProtocol {
        HomeFactory(dependencies: dependencies)
    }
}

