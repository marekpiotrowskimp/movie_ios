import XCTest
@testable import movie_ios

class CoordinationgMock: Coordinating {

    var invokedRootViewControllerGetter = false
    var invokedRootViewControllerGetterCount = 0
    var stubbedRootViewController: UIViewController!

    var rootViewController: UIViewController {
        invokedRootViewControllerGetter = true
        invokedRootViewControllerGetterCount += 1
        return stubbedRootViewController
    }

    var invokedShow = false
    var invokedShowCount = 0
    var invokedShowParameters: (destination: CoordinatorDestination, Void)?
    var invokedShowParametersList = [(destination: CoordinatorDestination, Void)]()

    func show(destination: CoordinatorDestination) {
        invokedShow = true
        invokedShowCount += 1
        invokedShowParameters = (destination, ())
        invokedShowParametersList.append((destination, ()))
    }
}
