//
//  AddTransactionViewController.swift
//  TransactionsTestTask
//
//  Created by Oleh Veheria on 06.01.2025.
//

import UIKit

class AddTransactionViewController: UIViewController {

    private let amountTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Enter amount"
        textField.keyboardType = .decimalPad
        textField.borderStyle = .roundedRect
        return textField
    }()

    private let categoryTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
        return tableView
    }()

    private let addButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Add", for: .normal)
        button.addTarget(self, action: #selector(didTapAdd), for: .touchUpInside)
        return button
    }()

    private var viewModel: AddTransactionViewModel!
    private var selectedCategory: TransactionCategory = .groceries

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        viewModel = AddTransactionViewModel(coreDataManager: CoreDataManagerImpl.shared)
    }

    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(amountTextField)
        view.addSubview(categoryTableView)
        view.addSubview(addButton)

        NSLayoutConstraint.activate([
            amountTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            amountTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            amountTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            categoryTableView.topAnchor.constraint(equalTo: amountTextField.bottomAnchor, constant: 16),
            categoryTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            categoryTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            categoryTableView.heightAnchor.constraint(equalToConstant: 220),

            addButton.topAnchor.constraint(equalTo: categoryTableView.bottomAnchor, constant: 16),
            addButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])

        categoryTableView.dataSource = self
        categoryTableView.delegate = self
        categoryTableView.register(UITableViewCell.self, forCellReuseIdentifier: "CategoryCell")
    }

    @objc private func didTapAdd() {
        guard let amountText = amountTextField.text, let amount = Double(amountText) else { return }
        viewModel.addTransaction(amount: amount, category: selectedCategory)
        navigationController?.popViewController(animated: true)
    }
}

extension AddTransactionViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TransactionCategory.allCases.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        let category = TransactionCategory.allCases[indexPath.row]
        cell.textLabel?.text = category.rawValue
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCategory = TransactionCategory.allCases[indexPath.row]
    }
}
