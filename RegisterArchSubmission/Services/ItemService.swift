protocol ItemService {
    func getItems() -> [MenuItem]
}

class StubItemService: ItemService {
    private let items = [
        MenuItem(id: 1, name: "Bagel", price: 1.49),
        MenuItem(id: 2, name: "Latte", price: 3.49),
        MenuItem(id: 3, name: "Personal Pizza", price: 8.99),
        MenuItem(id: 4, name: "Large Pizza", price: 12.99),
        MenuItem(id: 5, name: "Fries", price: 3.99),
        MenuItem(id: 6, name: "Chocolate Milk", price: 3.99),
        MenuItem(id: 7, name: "Donut", price: 3.49),
        MenuItem(id: 8, name: "Soda (1 liter)", price: 2.49),
        MenuItem(id: 9, name: "Beer (pint)", price: 8.99),
        MenuItem(id: 10, name: "Wine", price: 15.99)
    ]

    func getItems() -> [MenuItem] {
        return items
    }
}
