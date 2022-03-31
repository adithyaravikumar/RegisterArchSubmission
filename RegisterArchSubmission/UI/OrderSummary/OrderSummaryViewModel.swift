import Combine

class OrderSummaryViewModel {
    private let didPaySubject = PassthroughSubject<Void, Never>()
    let items: [BillItem]

    var didPayPublisher: AnyPublisher<Void, Never> {
        didPaySubject.eraseToAnyPublisher()
    }

    var paymentAmount: Double {
        var total: Double = 0
        items.forEach {
            let itemAmount = Double($0.quantity) * $0.price
            total += itemAmount
        }
        return total.rounded(to: 2)
    }

    init(items: [BillItem]) {
        self.items = items
    }

    func completePayment() {
        didPaySubject.send()
    }
}
