//
//  TotalProfitAndLossBottomView.swift
//  AkshayShedgeTask
//
//  Created by Akshay Shedge on 25/12/24.
//

import UIKit

final class TotalProfitAndLossBottomView: UIView {

    private let leftLabel = UILabel()
    private let rightLabel = UILabel()
    private let arrowImageView = UIImageView()
    private let leftStackView = UIStackView()

    private let horizontalStackView = UIStackView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        configureBackground()
        configureLabels()
        configureArrowImageView()
        configureHorizontalStackView()
        applyAutoLayoutConstraints()
        adjustContentHuggingAndCompression()
    }

    private func configureBackground() {
        backgroundColor = .background.darkWhite
    }

    private func configureLabels() {
        leftLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        leftLabel.textColor = .gray
        leftLabel.textAlignment = .left

        rightLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        rightLabel.textColor = .gray
        rightLabel.textAlignment = .right
    }

    private func configureArrowImageView() {
        arrowImageView.image = UIImage(systemName: "chevron.up") // Default image
        arrowImageView.contentMode = .scaleAspectFit
        arrowImageView.tintColor = .black

        // Add constraints for the arrow image
        arrowImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            arrowImageView.widthAnchor.constraint(equalToConstant: 16),
            arrowImageView.heightAnchor.constraint(equalToConstant: 16)
        ])
    }

    private func configureHorizontalStackView() {
        leftStackView.axis = .horizontal
        leftStackView.alignment = .center
        leftStackView.distribution = .fill
        leftStackView.spacing = 4 // Keep arrow close to the label
        leftStackView.addArrangedSubview(leftLabel)
        leftStackView.addArrangedSubview(arrowImageView)
        
        horizontalStackView.axis = .horizontal
        horizontalStackView.alignment = .center
        horizontalStackView.distribution = .fill
        horizontalStackView.spacing = 8
        addSubview(horizontalStackView)

        // Add left stack view and right label to the main horizontal stack view
        horizontalStackView.addArrangedSubview(leftStackView)
        horizontalStackView.addArrangedSubview(rightLabel)
    }

    private func applyAutoLayoutConstraints() {
        horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            horizontalStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            horizontalStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            horizontalStackView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            horizontalStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ])
    }

    private func adjustContentHuggingAndCompression() {
        leftStackView.setContentHuggingPriority(.required, for: .horizontal)
        leftStackView.setContentCompressionResistancePriority(.required, for: .horizontal)

        rightLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        rightLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
    }

    // Method to configure the view with data
    func configure(viewModel: ProfitLossCellViewModel) {
        leftLabel.text = viewModel.cellType.staticText

        let formattedValue = viewModel.value?.readableAmount ?? "₹0.00"
        let formattedPercentage = String(format: "%.2f", abs(viewModel.profitLossInPercentage ?? 0))

        if viewModel.tradeType == .profit {
            rightLabel.textColor = .systemGreen
            rightLabel.text = "\(formattedValue) (\(formattedPercentage)%)"
        } else {
            rightLabel.textColor = .systemRed
            rightLabel.text = "\(formattedValue) (\(formattedPercentage)%)"
        }
    }

    func toggleImage(isExpanded: Bool) {
        arrowImageView.image = isExpanded ? UIImage(systemName: "chevron.down") : UIImage(systemName: "chevron.up")
    }
}

