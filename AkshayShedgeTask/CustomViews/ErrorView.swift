//
//  ErrorView.swift
//  AkshayShedgeTask
//
//  Created by Akshay Shedge on 26/12/24.
//

import Foundation
import UIKit

final class ErrorView: UIView {

    // MARK: - Public Properties
    private var retryAction: (() -> Void)?

    // MARK: - Lazy UI Components
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .gray
        return imageView
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()

    private lazy var retryButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        configuration.title = "Retry"
        configuration.baseForegroundColor = .systemBlue
        configuration.baseBackgroundColor = .white
        configuration.cornerStyle = .medium
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20)
        configuration.background.strokeColor = .systemBlue
        configuration.background.strokeWidth = 1.0

        let button = UIButton(configuration: configuration)
        button.addTarget(self, action: #selector(retryButtonTapped), for: .touchUpInside)
        return button
    }()


    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [imageView, descriptionLabel, retryButton])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 20
        return stackView
    }()

    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    // MARK: - Public Methods
    func configure(image: UIImage?,
                   description: String,
                   retryAction: @escaping () -> Void) {
        imageView.image = image
        descriptionLabel.text = description
        self.retryAction = retryAction
    }

    // MARK: - Private Methods
    private func setupUI() {
        backgroundColor = .white
        addSubview(stackView)
        setupConstraints()
    }

    private func setupConstraints() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            // Stack View Constraints
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),

            // ImageView Size Constraints
            imageView.heightAnchor.constraint(equalToConstant: 100),
            imageView.widthAnchor.constraint(equalToConstant: 100),

            // Retry Button Size Constraints
            retryButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }

    @objc private func retryButtonTapped() {
        retryAction?()
    }
}
