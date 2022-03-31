import Combine

class BillRoute: Route {
    var selectedItem: AnyPublisher<MenuItem, Never>?
}
