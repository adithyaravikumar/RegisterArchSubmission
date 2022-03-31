//
//  ViewController.swift
//  RegisterArchSubmission
//
//  Created by Adithya Ravikumar on 3/25/22.
//

import UIKit

class TabController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let splitViewController = RouteMap.shared?.viewController(for: SplitViewContainerRoute()) else {
            return
        }
        let tabBarItem = UITabBarItem(title: "Home", image: nil, tag: 1)
        splitViewController.tabBarItem = tabBarItem
        self.viewControllers = [splitViewController]
    }
}

