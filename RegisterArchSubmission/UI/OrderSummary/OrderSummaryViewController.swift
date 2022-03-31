//
//  OrderSummaryViewController.swift
//  RegisterArchSubmission
//
//  Created by Adithya Ravikumar on 3/29/22.
//

import UIKit

class OrderSummaryViewController: UIViewController {

    private struct Constants {
        static let viewTitle = "Complete Payment"
        static let reuseIdentifier = "Cell"
    }

    private var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Constants.reuseIdentifier)
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    private var payButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 10.0
        button.layer.masksToBounds = true
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 20)
        button.backgroundColor = .systemBlue
        return button
    }()

    private let viewModel: OrderSummaryViewModel

    init(viewModel: OrderSummaryViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = Constants.viewTitle
        view.backgroundColor = .white
        tableView.dataSource = self
        view.addSubview(tableView)
        view.addSubview(payButton)

        // Layout the table
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.heightAnchor.constraint(equalToConstant: 200)
        ])

        // Layout the checkout button
        NSLayoutConstraint.activate([
            payButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            payButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            payButton.heightAnchor.constraint(equalToConstant: 75)
        ])
        configure(payButton)
    }

    @objc private func pay() {
        viewModel.completePayment()
        dismiss(animated: true, completion: nil)
    }

    private func configure(_ button: UIButton) {
        button.setTitle("Pay $\(viewModel.paymentAmount) Now", for: .normal)
        button.addTarget(self, action: #selector(pay), for: .touchUpInside)
    }

    private func configure(_ cell: UITableViewCell, for item: BillItem) {
        let price = (item.price * Double(item.quantity)).rounded(to: 2)
        cell.textLabel?.font = .boldSystemFont(ofSize: 18)
        cell.textLabel?.text = "\(item.name) X \(item.quantity)"
        cell.detailTextLabel?.text = "$\(price)"
        cell.selectionStyle = .none
    }
}

extension OrderSummaryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: Constants.reuseIdentifier)
        configure(cell, for: viewModel.items[indexPath.row])
        return cell
    }
}
