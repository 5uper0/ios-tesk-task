//
//  BalanceView.swift
//  TransactionsTestTask
//
//  Created by Oleh Veheria on 08.01.2025.
//

import UIKit

class BalanceView: UIView {

    private let balanceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        label.text = "Balance: 0 BTC"
        return label
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
        addSubview(balanceLabel)
        NSLayoutConstraint.activate([
            balanceLabel.topAnchor.constraint(equalTo: topAnchor),
            balanceLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            balanceLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            balanceLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    func updateBalance(_ balance: Double) {
        balanceLabel.text = "Balance: \(balance) BTC"
    }
}
