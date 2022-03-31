# Overview
This project outlines a way to launch UI using `Route`s. A `Route` gets registered on a `RouteMap` which defines what UI needs to be launched when that route is invoked.

### Structure of this app
- This app has a tab bar with a single tab.
- That tab has a split view controller with two child view controllers.
- The left child is the menu and the right child is the billing page.
- Tapping the checkout button launches a checkout page modally that has the order details.
- Paying for the order on checkout dismissis the modal and clears out the billing page so that we can take the next order.

### How does routing work?
Each view controller in this project has an associated route. These routes are registered in the `RouteFactory`. The routes can then be embedded/presented/pushed as needed. We provide this capability through extensions on `UIViewController`, `UINavigationController` and `UISplitViewController`. Here is a breakdown of the routes and associated controllers.

| Route           | Corresponding View Controller |
| --------------- | ----------------------------- |
| `TabBarRoute`   |`TabController`|
| `SplitViewContainerRoute`   |`SplitViewContainerViewController`|
| `MenuRoute`   |`MenuViewController`|
| `BillRoute`   |`BillViewController`|
| `OrderSummaryRoute`   |`OrderSummaryViewController`|

### How does the menu talk to the billing page?
The menu route looks like this. The publisher on this route will fire whenever the user taps an item on the menu.
```swift=
class MenuRoute: Route {
    var selectedItem: AnyPublisher<MenuItem, Never>?
}
```

When we register the `MenuRoute` in the `RouteFactory`, we do this:
```swift=
RouteMap.shared?.register(MenuRoute.self, { route in
    guard let menuRoute = route as? MenuRoute else {
        return nil
    }
    let menuViewModel = MenuViewModel(itemService: StubItemService())
    menuRoute.selectedItem = menuViewModel.selectedItemPublisher
    return MenuViewController(viewModel: menuViewModel)
})
```

This allows the view model to propagate information via the menu route.

Now let's take a look at the `BillRoute` to see how the published manu item gets to the billing page.
```swift=
class BillRoute: Route {
    var selectedItem: AnyPublisher<MenuItem, Never>?
}
```

As you can see, the bill route has a publisher property as well. Now, let's look at the `SplitViewContainerViewController` to see how this stuff is hooked up:
```swift=
// Add menu page to split vc
splitController.setEvent(viewModel.menuRoute, for: .primary)

// This step is important. This is how data flows from the menu to the bill screen
viewModel.billRoute.selectedItem = viewModel.menuRoute.selectedItem

// Add the bill page to the split vc
splitController.setEvent(viewModel.billRoute, for: .secondary)
```

By hooking up the `menuRoute`'s `selectedItem` with the `billRoute`'s `selectedItem`, we get data to flow from the menu to the billing page.

Note that in this specific example, ordering is important. The menu is where the data comes from so the menu view stack needs to be embedded to the split view controller first so that the `selectedItem` publisher isn't `nil` (since the event gets it from the view model). Then we hook it to the billing page's property and eventually embed the billing page to the split view controller on the last line.

### How does the billing page talk to the order summary modal?
The answer again lies in the route. The order summary route looks like this:

```swift=
class OrderSummaryRoute: Route {
    var didPay: AnyPublisher<Void, Never>?
    let items: [BillItem]

    init(items: [BillItem]) {
        self.items = items
    }
}
```

The `items` property is the input to that modal and the `didPay` publisher tells the billing page that the payment button was tapped. this helps the billing page to clear out the table view. And that's it.
