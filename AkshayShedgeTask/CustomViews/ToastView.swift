//
//  ToastView.swift
//  AkshayShedgeTask
//
//  Created by Akshay Shedge on 26/12/24.
//

import UIKit

class ToastView: UIView {

    private let messageLabel = UILabel()
    private let padding: CGFloat = 16.0
    private let displayDuration: TimeInterval = 3.0
    
    init(message: String) {
        super.init(frame: .zero)
        setupView(message: message)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView(message: String) {
        // Configure background
        backgroundColor = UIColor.black.withAlphaComponent(0.8)
        layer.cornerRadius = 8
        clipsToBounds = true

        // Configure message label
        messageLabel.text = message
        messageLabel.textColor = .white
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont.systemFont(ofSize: 14)
        
        // Add label to view
        addSubview(messageLabel)
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Add constraints
        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            messageLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding),
            messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding)
        ])
    }
    
    func show(in parentView: UIView) {
        // Add toast to parent view
        parentView.addSubview(self)
        
        // Set initial constraints for animation
        self.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: parentView.leadingAnchor, constant: 32),
            trailingAnchor.constraint(equalTo: parentView.trailingAnchor, constant: -32),
            bottomAnchor.constraint(equalTo: parentView.safeAreaLayoutGuide.bottomAnchor, constant: 100) // Start off-screen
        ])
        parentView.layoutIfNeeded()

        // Animate toast appearing
        UIView.animate(withDuration: 0.3, animations: {
            self.transform = CGAffineTransform(translationX: 0, y: -100)
        }) { _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + self.displayDuration) {
                self.hide()
            }
        }
    }

    private func hide() {
        // Animate toast disappearing
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 0
        }) { _ in
            self.removeFromSuperview()
        }
    }
}
