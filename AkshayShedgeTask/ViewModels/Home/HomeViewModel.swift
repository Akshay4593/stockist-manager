//
//  HomeViewModel.swift
//  AkshayShedgeTask
//
//  Created by Akshay Shedge on 24/12/24.
//

import Foundation

protocol HomeViewModelDelegate: AnyObject {
    
    func reloadData()
    func didUpdateLoadingState(isLoading: Bool)
    func didEncounterError(error: CustomError)
    func didReceiveEmptyResults()
    
    func updateProfitLossDetailView(viewModel: ProfitLossViewModel)
    
    func showToast(message: String)
    
    // if pagination comes in picture
    //func insertItems(at: [IndexPath])
}

final class HomeViewModel {
    
    let networkService: NetworkService
    
    private(set) var dataSource: [HomeCellViewModel] = []
    
    weak var delegate: HomeViewModelDelegate?
    
    init(networkService: NetworkService = NetworkManager.shared) {
        self.networkService = networkService
    }
    
    func fetchData() {
        delegate?.didUpdateLoadingState(isLoading: true)
        guard ReachabilityManager.shared.isConnected else {
            handleOfflineScenario()
            return
        }
        makeApiCall()
    }
    
    private func makeApiCall() {
        
        networkService.performRequest(path: HomeNetworking.usersHoldings,
                                      queryParams: nil, body: nil) {
            [weak self] (result: Result<HoldingsResponse, CustomError>) in
            
            guard let self = self else { return }
            
            self.delegate?.didUpdateLoadingState(isLoading: false)
            
            switch result {
            case .success(let holdingsResponse):
                self.processHoldingsResponse(holdingsResponse)
                
            case .failure(let error):
                print(error)
                DispatchQueue.main.async { [weak self] in
                    self?.delegate?.didEncounterError(error: error)

                }
                break
            }
            
        }
    }
    
    
    private func processHoldingsResponse(_ response: HoldingsResponse) {
        guard let userHoldings = response.data?.userHolding, !userHoldings.isEmpty else {
            // Notify delegate about empty results
            self.dataSource = []
            delegate?.didReceiveEmptyResults()
            return
        }
        saveToDatabase(userHoldings: userHoldings)
        makeDataSource(userHoldings: userHoldings)
    }
    
    func didSelect(index: Int) {
        
    }
}

// MARK: - UPDATE DATASOURCE
extension HomeViewModel {
   
    private func makeDataSource(userHoldings: [UserHolding]) {
        
        // Update data source
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }
            
            self.setupProfitLossViewData(userHoldings: userHoldings)
            
            //filtering out any nil objects
            let userHoldingsCellViewModels = userHoldings.compactMap { holding in
                return UserHoldingCellViewModel(userHolding: holding)
            }
            
            DispatchQueue.main.async {
                if userHoldingsCellViewModels.isEmpty {
                    self.dataSource = []
                    self.delegate?.didReceiveEmptyResults()
                } else {
                    self.dataSource = userHoldingsCellViewModels
                    self.delegate?.reloadData()
                }
            }
        }
        
    }
    
    private func setupProfitLossViewData(userHoldings: [UserHolding]) {
        let profitLossViewModel = ProfitLossViewModel(userHoldings: userHoldings)
        delegate?.updateProfitLossDetailView(viewModel: profitLossViewModel)
    }
    
}
// MARK: - DATABASE OPERATIONS
extension HomeViewModel {
    
    private func saveToDatabase(userHoldings: [UserHolding]) {
        
        DatabaseManager.shared.saveUserHoldings(userHoldings) { success, error in
            if success {
                print("User holdings saved successfully.")
            } else {
                print("Failed to save user holdings: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
    }
    
    private func fetchUserHoldingsFromDatabase(completion: @escaping ([UserHolding]?) -> Void) {
        DatabaseManager.shared.fetchUserHoldings { holdings, error in
            if let holdings = holdings {
                // Map the fetched entities to the UserHolding model
                let userHoldings = holdings.map { holding in
                    UserHolding(
                        symbol: holding.symbol,
                        quantity: holding.quantity,
                        ltp: holding.ltp,
                        avgPrice: holding.avgPrice,
                        close: holding.close
                    )
                }
                completion(userHoldings)
            } else {
                print("Failed to fetch user holdings: \(error?.localizedDescription ?? "Unknown error")")
                completion(nil)
            }
        }
    }

    private func handleOfflineScenario() {
        print("Waiting for internet connection...")
        
        fetchUserHoldingsFromDatabase { [weak self] userHoldings in
            self?.handleOfflineDataFetchResult(userHoldings)
        }
    }

    private func handleOfflineDataFetchResult(_ userHoldings: [UserHolding]?) {
        delegate?.didUpdateLoadingState(isLoading: false)
        guard let userHoldings = userHoldings else {
            print("No data found or an error occurred.")
            DispatchQueue.main.async { [weak self] in
                self?.delegate?.didEncounterError(error: .noInternet)

            }
            return
        }
        makeDataSource(userHoldings: userHoldings)
        delegate?.showToast(message: "The data might be outdated as you're offline.")
    }
}
