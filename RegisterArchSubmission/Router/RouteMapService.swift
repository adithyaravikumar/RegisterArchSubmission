import UIKit

typealias RouteHandler = ((Route) -> UIViewController?)

protocol RouteMapService {
    func register(_ route: Route.Type, _ handler: @escaping RouteHandler)
    func viewController(for route: Route) -> UIViewController?
}

class RegisterRouteMap: RouteMapService {
    private var routes: [String: RouteHandler] = [:]

    func register(_ route: Route.Type, _ handler: @escaping RouteHandler) {
        routes[route.name] = handler
    }

    func viewController(for route: Route) -> UIViewController? {
        guard let handler = routes[String(describing: type(of: route))] else {
            return nil
        }
        return handler(route)
    }
}
