import Combine

class BillViewModel {
    @Published var billItems: [BillItem] = []
    private var cancellables: [AnyCancellable] = []

    init(itemPublisher: AnyPublisher<MenuItem, Never>?) {
        itemPublisher?.sink(receiveValue: { [weak self] item in
            self?.save(item)
        }).store(in: &cancellables)
    }

    func clear() {
        billItems = []
    }

    private func save(_ item: MenuItem) {
        let billItem = BillItem.create(from: item, quantity: 1)
        if let index = billItems.firstIndex(where: { $0.id == billItem.id }) {
            var item = billItems[index]
            item.quantity += 1
            billItems[index] = item
        } else {
            billItems.append(billItem)
        }
    }
}
