import Combine

class MenuRoute: Route {
    var selectedItem: AnyPublisher<MenuItem, Never>?
}
