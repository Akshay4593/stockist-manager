//
//  UserHoldingTableViewCell.swift
//  AkshayShedgeTask
//
//  Created by Akshay Shedge on 24/12/24.
//

import UIKit

final class UserHoldingTableViewCell: UITableViewCell {
    
    // MARK: - UI Elements
    private let symbolLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .black
        return label
    }()
    
    private let ltpLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        return label
    }()
    
    private let netQtyLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        return label
    }()
    
    private let pnlLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        return label
    }()
    
    private let verticalStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8
        stack.alignment = .fill
        return stack
    }()
    
    private let topHorizontalStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 8
        stack.alignment = .center
        return stack
    }()
    
    private let bottomHorizontalStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 8
        stack.alignment = .center
        return stack
    }()
    
    private var viewModel: UserHoldingCellViewModel?
    
    // MARK: - Initializer
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // Configure top horizontal stack
        topHorizontalStackView.addArrangedSubview(symbolLabel)
        topHorizontalStackView.addArrangedSubview(ltpLabel)
        
        // Configure bottom horizontal stack
        bottomHorizontalStackView.addArrangedSubview(netQtyLabel)
        bottomHorizontalStackView.addArrangedSubview(pnlLabel)
        
        // Add horizontal stacks to vertical stack
        verticalStackView.addArrangedSubview(topHorizontalStackView)
        verticalStackView.addArrangedSubview(bottomHorizontalStackView)
        
        // Add vertical stack to content view
        contentView.addSubview(verticalStackView)
        
        // Set constraints
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Constraints
    private func setupConstraints() {
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            verticalStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            verticalStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            verticalStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            verticalStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    
    // MARK: - Configure Cell
    func configure(viewModel: UserHoldingCellViewModel) {
        self.viewModel = viewModel
        
        symbolLabel.text = viewModel.name
        
        let ltpText = createAttributedText(
            staticText: "LTP: ",
            dynamicValue: viewModel.ltp?.readableAmount ?? "₹0.00",
            dynamicValueColor: .black
        )

        let netQtyText = createAttributedText(
            staticText: "NET QTY: ",
            dynamicValue: "\(viewModel.quantiy ?? 0)",
            dynamicValueColor: .black
        )

        let tradeType = viewModel.tradeType
        let pnlText = createAttributedText(
            staticText: "P&L: ",
            dynamicValue: viewModel.profitAndLossAmount?.readableAmount ?? "₹0.00",
            dynamicValueColor: tradeType == .profit ? .systemGreen : .systemRed
        )

        ltpLabel.attributedText = ltpText
        netQtyLabel.attributedText = netQtyText
        pnlLabel.attributedText = pnlText
    }

    private func createAttributedText(
        staticText: String,
        dynamicValue: String,
        dynamicValueColor: UIColor
    ) -> NSAttributedString {
        let staticFont = UIFont.systemFont(ofSize: 12, weight: .regular)
        let dynamicFont = UIFont.systemFont(ofSize: 14, weight: .regular)
        
        let staticAttributes: [NSAttributedString.Key: Any] = [
            .font: staticFont,
            .foregroundColor: UIColor.gray
        ]
        
        let dynamicAttributes: [NSAttributedString.Key: Any] = [
            .font: dynamicFont,
            .foregroundColor: dynamicValueColor
        ]
        
        let attributedString = NSMutableAttributedString(string: staticText, attributes: staticAttributes)
        attributedString.append(NSAttributedString(string: dynamicValue, attributes: dynamicAttributes))
        
        return attributedString
    }

}
