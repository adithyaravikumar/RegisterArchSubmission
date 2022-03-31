struct BillItem {
    let id: Int
    let name: String
    let price: Double
    var quantity: Int

    static func create(from menuItem: MenuItem, quantity: Int) -> BillItem {
        return BillItem(id: menuItem.id,
                        name: menuItem.name,
                        price: menuItem.price,
                        quantity: quantity)
    }
}
