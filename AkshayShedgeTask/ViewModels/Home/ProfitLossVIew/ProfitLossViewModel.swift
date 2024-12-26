//
//  ProfitLossViewModel.swift
//  AkshayShedgeTask
//
//  Created by Akshay Shedge on 25/12/24.
//

import Foundation

final class ProfitLossViewModel {
    
    // Data source array to hold ProfitLossCellViewModel instances
    private(set) var datasource: [ProfitLossCellViewModel]
    let bottomViewModel: ProfitLossCellViewModel
    
    init(userHoldings: [UserHolding]) {
          let currentValue = PortfolioCalculator.calculateCurrentValue(from: userHoldings)
          let totalInvestment = PortfolioCalculator.calculateTotalInvestment(from: userHoldings)
          let todaysPNL = PortfolioCalculator.calculateTodaysPNL(from: userHoldings)
          let totalPNL = PortfolioCalculator.calculateTotalPNL(currentValue: currentValue, totalInvestment: totalInvestment)
          let totalPNLPercentage = PortfolioCalculator.calculateTotalPNLPercentage(totalPNL: totalPNL, totalInvestment: totalInvestment)
          
          // Determine profit/loss types
          let totalPNLType: TradeType = totalPNL >= 0 ? .profit : .loss
          let todaysPNLType: TradeType = todaysPNL >= 0 ? .profit : .loss
          
          // Populate the datasource array
          self.datasource = [
              ProfitLossCellViewModel(cellType: .currentValue, value: currentValue),
              ProfitLossCellViewModel(cellType: .totalInvestment, value: totalInvestment),
              ProfitLossCellViewModel(cellType: .todaysPNL, value: todaysPNL, tradeType: todaysPNLType)
          ]
          
          self.bottomViewModel = ProfitLossCellViewModel(
              cellType: .totalPNL,
              value: totalPNL,
              tradeType: totalPNLType,
              profitLossIndPercentage: totalPNLPercentage
          )
      }
    
}
