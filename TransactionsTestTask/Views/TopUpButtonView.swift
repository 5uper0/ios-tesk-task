//
//  TopUpButtonView.swift
//  TransactionsTestTask
//
//  Created by Oleh Veheria on 08.01.2025.
//

import UIKit

class TopUpButtonView: UIView {

    private let topUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Top Up", for: .normal)
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
        addSubview(topUpButton)
        NSLayoutConstraint.activate([
            topUpButton.topAnchor.constraint(equalTo: topAnchor),
            topUpButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            topUpButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            topUpButton.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    func setTarget(_ target: Any?, action: Selector, for controlEvents: UIControl.Event) {
        topUpButton.addTarget(target, action: action, for: controlEvents)
    }
}
