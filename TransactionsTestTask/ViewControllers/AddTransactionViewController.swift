//
//  AddTransactionViewController.swift
//  TransactionsTestTask
//
//  Created by Oleh Veheria on 06.01.2025.
//

import UIKit

class AddTransactionViewController: UIViewController {

    // MARK: - UI Elements
    private let amountTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Enter amount"
        textField.keyboardType = .decimalPad
        textField.borderStyle = .roundedRect
        return textField
    }()

    private let categorySegmentedControl: UISegmentedControl = {
        let categories = ["Groceries", "Taxi", "Electronics", "Restaurant", "Other"]
        let segmentedControl = UISegmentedControl(items: categories)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.selectedSegmentIndex = 0
        return segmentedControl
    }()

    private let addButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Add", for: .normal)
        button.addTarget(self, action: #selector(didTapAdd), for: .touchUpInside)
        return button
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    // MARK: - Setup UI
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(amountTextField)
        view.addSubview(categorySegmentedControl)
        view.addSubview(addButton)

        NSLayoutConstraint.activate([
            amountTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            amountTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            amountTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            categorySegmentedControl.topAnchor.constraint(equalTo: amountTextField.bottomAnchor, constant: 16),
            categorySegmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            categorySegmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            addButton.topAnchor.constraint(equalTo: categorySegmentedControl.bottomAnchor, constant: 16),
            addButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    // MARK: - Actions
    @objc private func didTapAdd() {
        // Handle add transaction action
        // For now, just dismiss the view controller
        navigationController?.popViewController(animated: true)
    }
}
