import Combine

class RouteFactory {
    static func registerRoutes() {
        // Tab bar
        RouteMap.shared?.register(TabBarRoute.self, { _ in
            return TabController()
        })

        // Split View Container
        RouteMap.shared?.register(SplitViewContainerRoute.self, { _ in
            let viewModel = SplitViewContainerViewModel()
            return SplitViewContainerViewController(viewModel: viewModel)
        })

        // Menu
        RouteMap.shared?.register(MenuRoute.self, { route in
            guard let menuRoute = route as? MenuRoute else {
                return nil
            }
            let menuViewModel = MenuViewModel(itemService: StubItemService())
            menuRoute.selectedItem = menuViewModel.selectedItemPublisher
            return MenuViewController(viewModel: menuViewModel)
        })

        // Color Display View
        RouteMap.shared?.register(BillRoute.self, { route in
            guard let billRoute = route as? BillRoute else {
                return nil
            }
            let billViewModel = BillViewModel(itemPublisher: billRoute.selectedItem)
            return BillViewController(viewModel: billViewModel)
        })

        // Order Summary
        RouteMap.shared?.register(OrderSummaryRoute.self, { route in
            guard let orderSummaryRoute = route as? OrderSummaryRoute else {
                return nil
            }
            let viewModel = OrderSummaryViewModel(items: orderSummaryRoute.items)
            orderSummaryRoute.didPay = viewModel.didPayPublisher
            return OrderSummaryViewController(viewModel: viewModel)
        })
    }
}
