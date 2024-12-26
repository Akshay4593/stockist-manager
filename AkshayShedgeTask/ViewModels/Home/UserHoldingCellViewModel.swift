//
//  HomeCellViewModel.swift
//  AkshayShedgeTask
//
//  Created by Akshay Shedge on 24/12/24.
//

import Foundation

protocol HomeCellViewModel: AnyObject {
    var cellType: HomeCellViewModelType { get }
}

enum HomeCellViewModelType {
    case userHoldings
}

enum TradeType {
    
    case profit
    case loss
}

final class UserHoldingCellViewModel: HomeCellViewModel {
    
    var cellType: HomeCellViewModelType {.userHoldings }
    
    let userHolding: UserHolding
    let profitAndLossAmount: Double?
    let tradeType: TradeType?
    
    var name: String? {
        userHolding.symbol
    }
    
    var ltp: Double? {
        userHolding.ltp
    }
    
    var quantiy: Int? {
        userHolding.quantity
    }

    init(userHolding: UserHolding) {
        self.userHolding = userHolding
        self.profitAndLossAmount = PortfolioCalculator.calculateProfitAndLoss(from: userHolding)
        self.tradeType = PortfolioCalculator.determineTradeType(from: userHolding)
    }

    
}
