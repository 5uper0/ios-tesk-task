//
//  AddTransactionButtonView.swift
//  TransactionsTestTask
//
//  Created by Oleh Veheria on 08.01.2025.
//

import UIKit

class AddTransactionButtonView: UIView {

    private let addTransactionButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Add Transaction", for: .normal)
        return button
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
        addSubview(addTransactionButton)
        NSLayoutConstraint.activate([
            addTransactionButton.topAnchor.constraint(equalTo: topAnchor),
            addTransactionButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            addTransactionButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            addTransactionButton.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    func setTarget(_ target: Any?, action: Selector, for controlEvents: UIControl.Event) {
        addTransactionButton.addTarget(target, action: action, for: controlEvents)
    }
}
