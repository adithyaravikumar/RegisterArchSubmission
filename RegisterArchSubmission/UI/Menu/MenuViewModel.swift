import Combine
import UIKit

class MenuViewModel {
    private let itemService: ItemService
    private let selectedItemSubject = PassthroughSubject<MenuItem, Never>()

    var selectedItemPublisher: Publishers.Share<AnyPublisher<MenuItem, Never>> {
        selectedItemSubject.eraseToAnyPublisher().share()
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
