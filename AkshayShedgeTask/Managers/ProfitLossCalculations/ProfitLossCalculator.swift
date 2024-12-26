//
//  ProfitLossCalculator.swift
//  AkshayShedgeTask
//
//  Created by Akshay Shedge on 26/12/24.
//

import Foundation

final class PortfolioCalculator {
    
    static func calculateCurrentValue(from userHoldings: [UserHolding]) -> Double {
        return userHoldings.reduce(0.0) { (result, holding) in
            result + (holding.ltp ?? 0.0) * Double(holding.quantity ?? 0)
        }
    }
    
    static func calculateTotalInvestment(from userHoldings: [UserHolding]) -> Double {
        return userHoldings.reduce(0.0) { (result, holding) in
            result + (holding.avgPrice ?? 0.0) * Double(holding.quantity ?? 0)
        }
    }
    
    static func calculateTodaysPNL(from userHoldings: [UserHolding]) -> Double {
        return userHoldings.reduce(0.0) { (result, holding) in
            if let ltp = holding.ltp, let close = holding.close, let quantity = holding.quantity {
                return result + (close - ltp) * Double(quantity)
            }
            return result
        }
    }
    
    static func calculateTotalPNL(currentValue: Double, totalInvestment: Double) -> Double {
        return (currentValue - totalInvestment).rounded(toPlaces: 2)
    }
    
    static func calculateTotalPNLPercentage(totalPNL: Double, totalInvestment: Double) -> Double {
        return totalInvestment > 0 ? (totalPNL / totalInvestment * 100).rounded(toPlaces: 2) : 0
    }
    
    static func calculateProfitAndLoss(from userHolding: UserHolding) -> Double? {
        guard let ltp = userHolding.ltp,
              let avgPrice = userHolding.avgPrice,
              let quantity = userHolding.quantity else {
            return nil
        }
        
        let pnl = (ltp - avgPrice) * Double(quantity)
        return pnl.rounded(toPlaces: 2)
    }
    
    static func determineTradeType(from userHolding: UserHolding) -> TradeType? {
        guard let ltp = userHolding.ltp, let avgPrice = userHolding.avgPrice else {
            return nil
        }
        
        return ltp >= avgPrice ? .profit : .loss
    }
}
