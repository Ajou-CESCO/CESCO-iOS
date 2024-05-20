//
//  RequestService.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 5/15/24.
//

import Foundation
import Moya
import CombineMoya
import Combine

class RequestService: RequestServiceType {
    let provider: MoyaProvider<RequestAPI>
    var cancellables = Set<AnyCancellable>()
    
    init(provider: MoyaProvider<RequestAPI>, cancellables: Set<AnyCancellable> = Set<AnyCancellable>()) {
        self.provider = provider
        self.cancellables = cancellables
    }
    
    /// 보호 관계 요청
    func relationRequest(receiverPhone: String) -> AnyPublisher<RequestRelationResponseModel, PillinTimeError> {
        return provider.requestPublisher(.requestRelation(receiverPhone))
            .tryMap { response in
                let decodedData = try response.map(RequestRelationResponseModel.self)
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
}
