//
//  ProfitLossCellViewModel.swift
//  AkshayShedgeTask
//
//  Created by Akshay Shedge on 25/12/24.
//

import Foundation

enum ProfitLossCellType {
    
    case currentValue
    case totalInvestment
    case totalPNL
    case todaysPNL
    
    var staticText: String {
        
        switch self {
        case .currentValue:
            "Current value"
        case .totalInvestment:
            "Total investment"
        case .totalPNL:
            "Profit & Loss"
        case .todaysPNL:
            "Today's Profit & Loss"
        }
    }
}

final class ProfitLossCellViewModel {
    
    let cellType: ProfitLossCellType
    let value: Double?
    let tradeType: TradeType?
    let profitLossInPercentage: Double?
    
    init(cellType: ProfitLossCellType,
         value: Double,
         tradeType: TradeType? = nil,
         profitLossIndPercentage: Double? = nil) {
        self.cellType = cellType
        self.value = value
        self.tradeType = tradeType
        self.profitLossInPercentage = profitLossIndPercentage
        
    }
}
