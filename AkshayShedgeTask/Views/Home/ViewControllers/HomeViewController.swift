//
//  HomeViewController.swift
//  AkshayShedgeTask
//
//  Created by Akshay Shedge on 24/12/24.
//

import UIKit

final class HomeViewController: UIViewController {
    
    private let tableView = UITableView()
    private let profitLossView = ProfitLossCollapsibleView()
    
    private lazy var loaderView: LoaderView = {
        let loader = LoaderView()
        return loader
    }()
    
    private lazy var errorView: ErrorView = {
        let errorView = ErrorView()
        errorView.translatesAutoresizingMaskIntoConstraints = false
        return errorView
    }()
    
    private var viewModel = HomeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
        viewModel.delegate = self
        viewModel.fetchData()
        addCollapsableView()
        addReachabilityObserver()
    }
    
}
// MARK: - Setup UI components
extension HomeViewController {
    
    private func setupUI() {
        view.backgroundColor = .white

        navigationItem.title = "Portfolio"
        
        // Add navigation bar items
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "person.circle"),
            style: .plain,
            target: self,
            action: #selector(profileTapped)
        )
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(
                image: UIImage(systemName: "magnifyingglass"),
                style: .plain,
                target: self,
                action: #selector(searchTapped)
            ),
            UIBarButtonItem(
                image: UIImage(systemName: "arrow.up.arrow.down"),
                style: .plain,
                target: self,
                action: #selector(sortTapped)
            )
        ]
        
        profitLossView.isHidden = true
    }

    private func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50)
        ])
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerCell(cellType: UserHoldingTableViewCell.self)
    }
    
    private func addCollapsableView() {
        view.addSubview(profitLossView)
        profitLossView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            profitLossView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            profitLossView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            profitLossView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
        ])
        
    }

}

// MARK: - Navigation Bar Actions
extension HomeViewController {
        
    @objc private func profileTapped() {
        print("Profile tapped")
    }
    
    @objc private func searchTapped() {
        print("Search tapped")
    }
    
    @objc private func sortTapped() {
        print("Sort tapped")
    }
}
// MARK: - Reachability Observer
extension HomeViewController {
    
    private func addReachabilityObserver() {
        
        ReachabilityManager.shared.onReachable = { [weak self] in
            print("Internet is active, retrying fetchData...")
            self?.viewModel.fetchData()
        }
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(cellType: UserHoldingTableViewCell.self,
                                                 for: indexPath)
        if let cellViewModel = viewModel.dataSource[indexPath.row] as? UserHoldingCellViewModel {
            cell.configure(viewModel: cellViewModel)
        }
        return cell
    }

    // MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

}
// MARK: - HomeViewModelDelegate methods
extension HomeViewController: HomeViewModelDelegate {
    
    func reloadData() {
        DispatchQueue.main.async { [weak self] in
            self?.removeErrorView()
            self?.tableView.reloadData()
        }
    }
    
    func updateProfitLossDetailView(viewModel: ProfitLossViewModel) {
        DispatchQueue.main.async { [weak self] in
            self?.profitLossView.isHidden = false
            self?.profitLossView.configure(viewModel: viewModel)
        }
    }
    
    func didUpdateLoadingState(isLoading: Bool) {
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {
                return
            }
            if isLoading {
                self.loaderView.showLoader(on: self.view)
                print("showing loader")
            } else {
                self.loaderView.hideLoader()
                print("hiding loader")
            }
        }

    }
    
    func didEncounterError(error: CustomError) {
        DispatchQueue.main.async { [weak self] in
            print("Encountered error: \(error.description)")
            self?.showErrorView(message: error.errroMessage,
                                retryAction: { [weak self] in
                print("Retrying fetchData from error view...")
                self?.viewModel.fetchData()
            })
        }
    }
    
    func didReceiveEmptyResults() {
        DispatchQueue.main.async { [weak self] in
            print("Received empty results")
            self?.showErrorView(
                message: CustomError.noInternet.errroMessage,
                retryAction: { [weak self] in
                    print("Retrying fetchData from empty results view...")
                    self?.viewModel.fetchData()
                }
            )
        }
    }
    
    func showToast(message: String) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {
                return
            }
            let toastView = ToastView(message: message)
            toastView.show(in: self.view)
        }
    }
    
}
// MARK: - Error view methods
extension HomeViewController {
    
     private func showErrorView(message: String, retryAction: @escaping () -> Void) {
         if errorView.superview == nil {
             view.addSubview(errorView)
             NSLayoutConstraint.activate([
                 errorView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                 errorView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                 errorView.topAnchor.constraint(equalTo: view.topAnchor),
                 errorView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
             ])
         }
         
         // Configure the error view
         errorView.configure(
             image: UIImage(systemName: "exclamationmark.circle"),
             description: message,
             retryAction: retryAction
         )
     }
     
     private func removeErrorView() {
         errorView.removeFromSuperview()
     }
    
    
}
