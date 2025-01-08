//
//  TransactionListView.swift
//  TransactionsTestTask
//
//  Created by Oleh Veheria on 08.01.2025.
//

import UIKit

class TransactionListView: UIView {

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
        return tableView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    private func setupUI() {
        addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    func setDataSource(_ dataSource: UITableViewDataSource) {
        tableView.dataSource = dataSource
    }

    func setDelegate(_ delegate: UITableViewDelegate) {
        tableView.delegate = delegate
    }

    func registerCell(_ cellClass: AnyClass, forCellReuseIdentifier identifier: String) {
        tableView.register(cellClass, forCellReuseIdentifier: identifier)
    }

    func reloadData() {
        tableView.reloadData()
    }
}
