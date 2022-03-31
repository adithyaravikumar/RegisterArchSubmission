import Combine
import UIKit

class MenuViewModel {
    private let itemService: ItemService
    private let selectedItemSubject = PassthroughSubject<MenuItem, Never>()

    var selectedItemPublisher: AnyPublisher<MenuItem, Never> {
        selectedItemSubject.eraseToAnyPublisher()
    }
    
    var menuItems: [MenuItem] {
        itemService.getItems()
    }

    init(itemService: ItemService) {
        self.itemService = itemService
    }

    func didSelect(_ item: MenuItem) {
        selectedItemSubject.send(item)
    }
}
