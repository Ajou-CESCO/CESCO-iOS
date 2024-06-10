//
//  PaymentService.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 6/10/24.
//

import Foundation
import Moya
import CombineMoya
import Combine

class PaymentService: PaymentServiceType {
    let provider: MoyaProvider<PaymentAPI>
    var cancellables = Set<AnyCancellable>()
    
    init(provider: MoyaProvider<PaymentAPI>, cancellables: Set<AnyCancellable> = Set<AnyCancellable>()) {
        self.provider = provider
        self.cancellables = cancellables
    }
    
    func requestPaymentInfo(memberId: Int) -> AnyPublisher<RequestPaymentInfoResponseModel, PillinTimeError> {
        return provider.requestPublisher(.requestPaymentInfo(memberId))
            .tryMap { response in
                let decodedData = try response.map(RequestPaymentInfoResponseModel.self)
                return decodedData
            }
            .mapError { error in
                print("error:", error)
                if error is MoyaError {
                    return PillinTimeError.networkFail
                } else {
                    return error as! PillinTimeError
                }
            }
            .eraseToAnyPublisher()
    }
    
    func requestSuccessPayment(paymentKey: String, orderId: String, amount: Int) -> AnyPublisher<BaseResponse<BlankData>, PillinTimeError> {
        return provider.requestPublisher(.requestSuccessPayment(paymentKey, orderId, amount))
            .tryMap { response in
                guard let httpResponse = response.response, httpResponse.statusCode == 200 else {
                    let errorResponse = try response.map(BaseResponse<BlankData>.self)
                    throw PillinTimeError.networkFail
                }
                return try response.map(BaseResponse<BlankData>.self)
            }
            .mapError { error in
                print("error:", error)
                if error is MoyaError {
                    return PillinTimeError.networkFail
                } else {
                    return error as! PillinTimeError
                }
            }
            .eraseToAnyPublisher()
    }
}
