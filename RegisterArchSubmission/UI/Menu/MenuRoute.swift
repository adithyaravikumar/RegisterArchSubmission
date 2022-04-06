import Combine

class MenuRoute: Route {
    var selectedItem: Publishers.Share<AnyPublisher<MenuItem, Never>>?
}
