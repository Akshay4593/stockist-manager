//
//  HoldingResponseModel.swift
//  AkshayShedgeTask
//
//  Created by Akshay Shedge on 24/12/24.
//

import Foundation

struct HoldingsResponse: Decodable {
    let data: HoldingsData?
}

struct HoldingsData: Decodable {
    let userHolding: [UserHolding]?
}

struct UserHolding: Decodable {
    let symbol: String?
    let quantity: Int?
    let ltp: Double?
    let avgPrice: Double?
    let close: Double?
}
