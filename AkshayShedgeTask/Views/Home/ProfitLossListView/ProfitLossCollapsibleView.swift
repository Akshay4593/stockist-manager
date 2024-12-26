//
//  ProfitLossCollapsibleView.swift
//  AkshayShedgeTask
//
//  Created by Akshay Shedge on 24/12/24.
//

import UIKit

class ProfitLossCollapsibleView: UIView {

    // Subviews
    private let containerView = UIView()
    private let stackView = UIStackView()
    private let tableView = UITableView()
    
    // bottom view
    private let bottomView = TotalProfitAndLossBottomView()
    
    // Data source for the table view
    private(set) var datasource: [ProfitLossCellViewModel]?
    
    private var isExpanded = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        setupContainerView()
        setupStackView()
        setupTableView()
        setupBottomView()
    }

    private func setupContainerView() {
        containerView.backgroundColor = .background.darkWhite
        containerView.layer.cornerRadius = 12
        containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        containerView.clipsToBounds = true
        addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    private func setupStackView() {
        stackView.axis = .vertical
        stackView.spacing = 0
        stackView.backgroundColor = .clear
        containerView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: containerView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
    }

    private func setupTableView() {
        tableView.isHidden = true
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .clear
        tableView.registerCell(cellType: ProfitLossTableViewCell.self)
        stackView.addArrangedSubview(tableView)
    }

    private func setupBottomView() {
        bottomView.backgroundColor = .lightGray.withAlphaComponent(0.2)
        bottomView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(toggleTableView)))
        stackView.addArrangedSubview(bottomView)
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        bottomView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
    }

        
    @objc private func toggleTableView() {
        isExpanded.toggle()
        tableView.isHidden = !isExpanded
        bottomView.toggleImage(isExpanded: isExpanded)
        UIView.animate(withDuration: 0.3) {
            self.invalidateIntrinsicContentSize()
            self.superview?.layoutIfNeeded()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        if isExpanded {
            return CGSize(width: UIView.noIntrinsicMetric, height: tableView.contentSize.height + 50)
        } else {
            return CGSize(width: UIView.noIntrinsicMetric, height: 50)
        }
    }
    
    func configure(viewModel: ProfitLossViewModel) {
        datasource = viewModel.datasource
        bottomView.configure(viewModel: viewModel.bottomViewModel)
        tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension ProfitLossCollapsibleView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(cellType: ProfitLossTableViewCell.self,
                                                 for: indexPath)
        
        if let cellViewModel = datasource?[indexPath.row] {
            cell.configure(viewModel: cellViewModel)
        }
        return cell
    }
}
