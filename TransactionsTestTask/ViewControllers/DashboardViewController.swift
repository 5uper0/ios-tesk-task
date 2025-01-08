//
//  DashboardViewController.swift
//  TransactionsTestTask
//
//  Created by Oleh Veheria on 06.01.2025.
//

import UIKit

class DashboardViewController: UIViewController {

    // MARK: - UI Elements
    private let balanceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        return label
    }()

    private let topUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Top Up", for: .normal)
        button.addTarget(self, action: #selector(didTapTopUp), for: .touchUpInside)
        return button
    }()

    private let addTransactionButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Add Transaction", for: .normal)
        button.addTarget(self, action: #selector(didTapAddTransaction), for: .touchUpInside)
        return button
    }()

    private let transactionsTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    private let exchangeRateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textAlignment = .right
        return label
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    // MARK: - Setup UI
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(balanceLabel)
        view.addSubview(topUpButton)
        view.addSubview(addTransactionButton)
        view.addSubview(transactionsTableView)
        view.addSubview(exchangeRateLabel)

        NSLayoutConstraint.activate([
            balanceLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            balanceLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            topUpButton.topAnchor.constraint(equalTo: balanceLabel.bottomAnchor, constant: 8),
            topUpButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            addTransactionButton.topAnchor.constraint(equalTo: topUpButton.bottomAnchor, constant: 16),
            addTransactionButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            transactionsTableView.topAnchor.constraint(equalTo: addTransactionButton.bottomAnchor, constant: 16),
            transactionsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            transactionsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            transactionsTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),

            exchangeRateLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            exchangeRateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])

        transactionsTableView.dataSource = self
        transactionsTableView.delegate = self
        transactionsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "TransactionCell")
    }

    // MARK: - Actions
    @objc private func didTapTopUp() {
        // Handle top-up action
    }

    @objc private func didTapAddTransaction() {
        // Handle add transaction action
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension DashboardViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0 // Placeholder
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionCell", for: indexPath)
        cell.textLabel?.text = "Transaction \(indexPath.row + 1)" // Placeholder
        return cell
    }
}
