import Combine

class OrderSummaryRoute: Route {
    var didPay: AnyPublisher<Void, Never>?
    let items: [BillItem]

    init(items: [BillItem]) {
        self.items = items
    }
}
