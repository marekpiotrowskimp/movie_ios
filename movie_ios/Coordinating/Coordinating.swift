import UIKit

enum CoordinatorDestination {
    case movieDetails(Int)
    case home
}

protocol Coordinating {
    var rootViewController: UIViewController { get }
    func show(destination: CoordinatorDestination)
}
