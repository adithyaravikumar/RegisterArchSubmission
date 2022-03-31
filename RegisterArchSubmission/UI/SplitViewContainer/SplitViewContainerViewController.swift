import Combine
import UIKit

class SplitViewContainerViewController: UIViewController {
    // Split view controller
    private var splitController: UISplitViewController = {
        let viewController = UISplitViewController(style: .doubleColumn)
        viewController.view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        return viewController
    }()

    private let viewModel: SplitViewContainerViewModel

    init(viewModel: SplitViewContainerViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Add the split view controller's view hierarchy to the container.
        self.addChild(splitController)
        self.view.addSubview(splitController.view)
        splitController.view.frame = self.view.bounds
        splitController.didMove(toParent: self)

        // Add menu page to split vc
        splitController.setEvent(viewModel.menuRoute,
                                 for: .primary)

        // This step is important. This is how data flows from the menu to the bill screen
        viewModel.billRoute.selectedItem = viewModel.menuRoute.selectedItem

        // Add the bill page to the split vc
        splitController.setEvent(viewModel.billRoute,
                                 for: .secondary)
    }
}
