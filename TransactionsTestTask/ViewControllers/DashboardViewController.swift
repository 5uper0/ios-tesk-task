//
//  DashboardViewController.swift
//  TransactionsTestTask
//
//  Created by Oleh Veheria on 06.01.2025.
//

import UIKit
import Combine

class DashboardViewController: UIViewController {

    private let balanceView = BalanceView()
    private let topUpButtonView = TopUpButtonView()
    private let addTransactionButtonView = AddTransactionButtonView()
    private let transactionListView = TransactionListView()
    private let exchangeRateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textAlignment = .center
        label.text = "1 BTC = $0.00"
        return label
    }()
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .fill
        return stackView
    }()

    private var viewModel: DashboardViewModel!
    private var cancellables = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
        setupObservers()
    }

    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(stackView)
        view.addSubview(transactionListView)

        stackView.addArrangedSubview(balanceView)
        stackView.addArrangedSubview(exchangeRateLabel)
        stackView.addArrangedSubview(topUpButtonView)
        stackView.addArrangedSubview(addTransactionButtonView)

        balanceView.translatesAutoresizingMaskIntoConstraints = false
        topUpButtonView.translatesAutoresizingMaskIntoConstraints = false
        addTransactionButtonView.translatesAutoresizingMaskIntoConstraints = false
        transactionListView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            transactionListView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 16),
            transactionListView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            transactionListView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            transactionListView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])

        transactionListView.setDataSource(self)
        transactionListView.setDelegate(self)
        transactionListView.registerCell(TransactionCell.self, forCellReuseIdentifier: "TransactionCell")

        topUpButtonView.setTarget(self, action: #selector(didTapTopUp), for: .touchUpInside)
        addTransactionButtonView.setTarget(self, action: #selector(didTapAddTransaction), for: .touchUpInside)
    }

    private func setupBindings() {
        viewModel = DashboardViewModel(coreDataManager: CoreDataManagerImpl.shared, bitcoinRateService: BitcoinRateServiceImpl(analyticsService: AnalyticsServiceImpl(), coreDataManager: CoreDataManagerImpl.shared))

        viewModel.$balance
            .sink { [weak self] balance in
                self?.balanceView.updateBalance(balance)
            }
            .store(in: &cancellables)

        viewModel.$transactions
            .sink { [weak self] _ in
                self?.transactionListView.reloadData()
            }
            .store(in: &cancellables)

        viewModel.$bitcoinRate
            .sink { [weak self] rate in
                self?.exchangeRateLabel.text = "1 BTC = $\(rate)"
            }
            .store(in: &cancellables)
    }

    private func setupObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleTransactionAdded), name: .transactionAdded, object: nil)
    }

    @objc private func handleTransactionAdded() {
        viewModel.fetchTransactions()
        viewModel.updateBalance()
    }

    @objc private func didTapTopUp() {
        let alertController = UIAlertController(title: "Top Up", message: "Enter amount in BTC", preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = "Amount"
            textField.keyboardType = .decimalPad
        }
        let confirmAction = UIAlertAction(title: "Confirm", style: .default) { [weak self] _ in
            if let amountText = alertController.textFields?.first?.text, let amount = Double(amountText) {
                self?.viewModel.topUpBalance(amount: amount)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }

    @objc private func didTapAddTransaction() {
        let addTransactionVC = AddTransactionViewController()
        navigationController?.pushViewController(addTransactionVC, animated: true)
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension DashboardViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.transactions.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionCell", for: indexPath) as! TransactionCell
        let transaction = viewModel.transactions[indexPath.row]
        let category = TransactionCategory(rawValue: transaction.category ?? "") ?? .other
        cell.configure(with: category.rawValue, amount: transaction.amount, category: category.rawValue, date: transaction.date ?? Date())
        return cell
    }
}
