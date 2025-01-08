//
//  TransactionCell.swift
//  TransactionsTestTask
//
//  Created by Oleh Veheria on 08.01.2025.
//

import UIKit

class TransactionCell: UITableViewCell {

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return label
    }()

    private let amountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textAlignment = .right
        return label
    }()

    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: .light)
        return label
    }()

    private let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: .light)
        label.textAlignment = .right
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(amountLabel)
        contentView.addSubview(categoryLabel)
        contentView.addSubview(dateLabel)

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),

            amountLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            amountLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),

            categoryLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            categoryLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            categoryLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),

            dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            dateLabel.topAnchor.constraint(equalTo: amountLabel.bottomAnchor, constant: 4),
            dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }

    func configure(with title: String, amount: Double, category: String, date: Date) {
        titleLabel.text = title
        amountLabel.text = "\(amount) BTC"
        categoryLabel.text = category
        dateLabel.text = DateFormatter.localizedString(from: date, dateStyle: .short, timeStyle: .short)
    }
}
