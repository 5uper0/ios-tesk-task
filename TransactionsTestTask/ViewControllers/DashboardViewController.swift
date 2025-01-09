//
//  DashboardViewController.swift
//  TransactionsTestTask
//
//  Created by Oleh Veheria on 06.01.2025.
//

import UIKit
import Combine

final class DashboardViewController: UIViewController {

    private let balanceView = BalanceView()
    private let topUpButtonView = TopUpButtonView()
    private let addTransactionButtonView = AddTransactionButtonView()
    private let transactionListView = TransactionListView()
    private let exchangeRateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textAlignment = .right
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
    private let headerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 4
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

        headerStackView.addArrangedSubview(exchangeRateLabel)
        headerStackView.addArrangedSubview(balanceView)

        stackView.addArrangedSubview(headerStackView)
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

        viewModel.$groupedTransactions
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
        viewModel.fetchTransactionsAndUpdateBalance()
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
        return viewModel.groupedTransactions.keys.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sortedKeys = viewModel.groupedTransactions.keys.sorted(by: >)
        return sortedKeys[safe: section]
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sortedKeys = viewModel.groupedTransactions.keys.sorted(by: >)
        guard let key = sortedKeys[safe: section] else { return 0 }
        return viewModel.groupedTransactions[key]?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionCell", for: indexPath) as! TransactionCell
        let sortedKeys = viewModel.groupedTransactions.keys.sorted(by: >)
        guard let key = sortedKeys[safe: indexPath.section],
              let transaction = viewModel.groupedTransactions[key]?[safe: indexPath.row] else {
            return cell
        }
        let category = TransactionCategory(rawValue: transaction.category ?? "") ?? .other
        let title = transaction.type == TransactionType.income.rawValue ? "Income" : "Spending"
        let sign = transaction.type == TransactionType.income.rawValue ? "+" : "-"
        cell.configure(with: title, sign: sign, amount: transaction.amount, category: category.rawValue, date: transaction.date ?? Date())
        return cell
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let sortedKeys = viewModel.groupedTransactions.keys.sorted(by: >)
        guard let key = sortedKeys[safe: indexPath.section] else { return }
        if indexPath.row == (viewModel.groupedTransactions[key]?.count ?? 0) - 1 && indexPath.section == sortedKeys.count - 1 {
            viewModel.loadMoreTransactions()
        }
    }
}

// MARK: - Safe Array Access
extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
