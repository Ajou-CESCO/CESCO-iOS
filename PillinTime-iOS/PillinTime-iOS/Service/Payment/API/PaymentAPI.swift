//
//  PaymentAPI.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 6/10/24.
//

import Foundation
import Moya

enum PaymentAPI {
    case requestPaymentInfo(_ memberId: Int)
    case requestSuccessPayment(_ paymentKey: String, _ orderId: String, _ amount: Int)
}

extension PaymentAPI: TargetType {
    var baseURL: URL {
        guard let url = URL(string: Config.baseURL) else {
            fatalError("baseURL could not be configured")
        }
        
        return url
    }
    
    var path: String {
        switch self {
        case .requestPaymentInfo:
            return "/api/payment/toss"
        case .requestSuccessPayment:
            return "/api/payment/toss/success"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .requestPaymentInfo:
            return .post
        case .requestSuccessPayment:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .requestPaymentInfo(let memberId):
            return .requestJSONEncodable(["memberId": memberId])
        case .requestSuccessPayment(let paymentKey, let orderId, let amount):
            return .requestParameters(parameters: ["paymentKey": paymentKey, "orderId": orderId, "amount": amount], encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String: String]? {
        return Config.defaultHeader
    }
}
