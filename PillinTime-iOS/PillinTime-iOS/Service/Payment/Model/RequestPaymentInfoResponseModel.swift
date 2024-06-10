//
//  RequestPaymentInfoResponseModel.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 6/10/24.
//

import Foundation

// MARK: - RequestPaymentInfoResponseModel
struct RequestPaymentInfoResponseModel: Codable {
    let status: Int
    let message: String
    let result: RequestPaymentInfoResponseModelResult
}

// MARK: - RequestPaymentInfoResponseModelResult
struct RequestPaymentInfoResponseModelResult: Codable {
    let payType: String
    let amount: Int
    let orderID, orderName: String
    let successURL, failURL: String

    enum CodingKeys: String, CodingKey {
        case payType, amount
        case orderID = "orderId"
        case orderName
        case successURL = "successUrl"
        case failURL = "failUrl"
    }
}
