import UIKit

extension UINavigationController {
    func push(_ route: Route, animated: Bool) {
        guard let viewController = RouteMap.shared?.viewController(for: route) else {
            return
        }
        pushViewController(viewController, animated: animated)
    }
}

extension UIViewController {
    func present(_ route: Route, animated flag: Bool, completion: (() -> Void)? = nil) {
        guard let viewController = RouteMap.shared?.viewController(for: route) else {
            return
        }
        present(viewController, animated: flag, completion: completion)
    }
}

extension UISplitViewController {
    func setEvent(_ route: Route, for column: UISplitViewController.Column) {
        guard let viewController = RouteMap.shared?.viewController(for: route) else {
            return
        }
        setViewController(viewController, for: column)
    }
}
