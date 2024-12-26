//
//  Double+Extensions.swift
//  AkshayShedgeTask
//
//  Created by Akshay Shedge on 25/12/24.
//

import Foundation

extension Double {
    
    func rounded(toPlaces places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
    
    
}

extension Double {
    var readableAmount: String {
        // Check if the value is negative
        let isNegative = self < 0
        
        // Format the number with commas and 2 decimal places
        let formattedAmount = String(format: "%0.2f", abs(self))

        // Add commas to the formatted amount
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.minimumFractionDigits = 2
        numberFormatter.maximumFractionDigits = 2
        let formattedWithCommas = numberFormatter.string(from: NSNumber(value: Double(formattedAmount) ?? 0)) ?? formattedAmount
        
        // Return the value with the correct sign and currency symbol
        return isNegative ? "-₹\(formattedWithCommas)" : "₹\(formattedWithCommas)"
    }
}

