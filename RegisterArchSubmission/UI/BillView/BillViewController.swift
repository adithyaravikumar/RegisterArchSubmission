import Combine
import UIKit

class BillViewController: UIViewController {

    private struct Constants {
        static let viewTitle = "Cart"
        static let reuseIdentifier = "BillCell"
    }

    private var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Constants.reuseIdentifier)
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    private var checkoutButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 10.0
        button.layer.masksToBounds = true
        button.setTitle("Checkout", for: .normal)
        button.setTitleColor(.lightGray, for: .disabled)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 20)
        return button
    }()

    private var rows: [BillItem] = [] {
        didSet {
            tableView.reloadData()
            checkoutButton.isEnabled = !rows.isEmpty
            checkoutButton.backgroundColor = rows.isEmpty ? .systemGray3 : .systemBlue
        }
    }

    private let viewModel: BillViewModel
    private(set) var cancellables: [AnyCancellable] = []

    init(viewModel: BillViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        cancellables.forEach { $0.cancel() }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = Constants.viewTitle
        view.backgroundColor = .white
        tableView.dataSource = self
        view.addSubview(tableView)
        view.addSubview(checkoutButton)

        // Layout the table
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.8)
        ])

        // Layout the checkout button
        NSLayoutConstraint.activate([
            checkoutButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            checkoutButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            checkoutButton.widthAnchor.constraint(equalToConstant: 150),
            checkoutButton.heightAnchor.constraint(equalToConstant: 75)
        ])
        setupBindings()
    }

    private func setupBindings() {
        // Listen for updates on the billed items
        viewModel.$billItems.sink { [weak self] items in
            self?.rows = items
        }.store(in: &cancellables)
        checkoutButton.addTarget(self, action: #selector(checkoutButtonTapped), for: .touchUpInside)
    }

    @objc private func checkoutButtonTapped() {
        let orderSummaryEvent = OrderSummaryRoute(items: rows)
        self.present(orderSummaryEvent, animated: true)
        orderSummaryEvent.didPay?.sink(receiveValue: { [weak self] in
            self?.viewModel.clear()
        }).store(in: &cancellables)
    }

    private func configure(_ cell: UITableViewCell, for item: BillItem) {
        let price = (item.price * Double(item.quantity)).rounded(to: 2)
        cell.textLabel?.font = .boldSystemFont(ofSize: 18)
        cell.textLabel?.text = "\(item.name) X \(item.quantity)"
        cell.detailTextLabel?.text = "$\(price)"
    }
}

extension BillViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rows.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: Constants.reuseIdentifier)
        configure(cell, for: viewModel.billItems[indexPath.row])
        return cell
    }
}
