//
//  ProfitLossTableViewCell.swift
//  AkshayShedgeTask
//
//  Created by Akshay Shedge on 25/12/24.
//


import UIKit

final class ProfitLossTableViewCell: UITableViewCell {
    
    // Create labels
    private let leftLabel = UILabel()
    private let rightLabel = UILabel()
    
    // Create stack view
    private let horizontalStackView = UIStackView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        backgroundColor = .clear
        
        // Configure labels
        leftLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        leftLabel.textColor = .gray
        leftLabel.textAlignment = .left
        leftLabel.backgroundColor = .clear
        
        rightLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        rightLabel.textColor = .gray
        rightLabel.textAlignment = .right
        rightLabel.backgroundColor = .clear

        
        // Configure stack view
        horizontalStackView.axis = .horizontal
        horizontalStackView.alignment = .center
        horizontalStackView.distribution = .fill
        horizontalStackView.spacing = 8
        horizontalStackView.backgroundColor = .clear
        contentView.addSubview(horizontalStackView)
        
        // Add labels to the stack view
        horizontalStackView.addArrangedSubview(leftLabel)
        horizontalStackView.addArrangedSubview(rightLabel)
        
        // Enable Auto Layout for the stack view
        horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
        
        // Set constraints for the stack view
        NSLayoutConstraint.activate([
            horizontalStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            horizontalStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            horizontalStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            horizontalStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    
    // Configure cell with data
    func configure(viewModel: ProfitLossCellViewModel) {
        leftLabel.text = viewModel.cellType.staticText

        if viewModel.cellType == .todaysPNL {
            // Use readableAmount for formatted value
            let formattedValue = (viewModel.value ?? 0).readableAmount
            rightLabel.textColor = viewModel.tradeType == .profit ? .systemGreen : .systemRed
            rightLabel.text = formattedValue // No need for explicit "-" symbol
        } else {
            // Use readableAmount for formatted value
            let formattedValue = (viewModel.value ?? 0).readableAmount
            rightLabel.text = formattedValue
        }
    }



}
