import Combine

class BillRoute: Route {
    var selectedItem: Publishers.Share<AnyPublisher<MenuItem, Never>>?
}
