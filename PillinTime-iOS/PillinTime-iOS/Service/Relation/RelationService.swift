//
//  RelationService.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 5/25/24.
//

import Foundation
import Moya
import CombineMoya
import Combine

/// RelationAPI Error
enum RelationError: Error {
    case createRelation(_: CreateRelationError)
    
    var description: String {
        switch self {
        case .createRelation(let error):
            return error.description
        }
    }
}

extension RelationError {
    enum CreateRelationError: Error {
        case createFailed
        case duplicatedUser // 40008
        case managerIsNotPremium  // 40302
        
        var description: String {
            switch self {
            case .createFailed:
                return "보호 관계 요청에 실패하였습니다."
            case .duplicatedUser:
                return "이미 보호 관계가 맺어져있는 사용자입니다."
            case .managerIsNotPremium:
                return "프리미엄 상품을 결제해야 이용 가능합니다."
            }
        }
    }
}

class RelationService: RelationServiceType {
    let provider: MoyaProvider<RelationAPI>
    var cancellables = Set<AnyCancellable>()
    
    init(provider: MoyaProvider<RelationAPI>, cancellables: Set<AnyCancellable> = Set<AnyCancellable>()) {
        self.provider = provider
        self.cancellables = cancellables
    }
    
    // 보호관계 생성 요청
    func createRelation(id: Int) -> AnyPublisher<BaseResponse<BlankData>, RelationError> {
        return provider.requestPublisher(.createRelation(id))
            .tryMap { response in
                let decodedData = try response.map(SignInResponseModel.self)
                if decodedData.status == 40008 {
                    throw RelationError.createRelation(.duplicatedUser)
                }
                if decodedData.status == 40302 {
                    throw RelationError.createRelation(.managerIsNotPremium)
                }
                return try response.map(BaseResponse<BlankData>.self)
            }
            .mapError { error in
                print("error:", error)
                if error is MoyaError {
                    return RelationError.createRelation(.createFailed)
                } else {
                    return error as! RelationError
                }
            }
            .eraseToAnyPublisher()
    }
    
    // 보호관계 리스트 조회
    func getRelationList() -> AnyPublisher<GetRelationListResponseModel, PillinTimeError> {
        return provider.requestPublisher(.getRelation)
            .tryMap { response in
                let decodeData = try response.map(GetRelationListResponseModel.self)
                return decodeData
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
    
    // 보호관계 삭제 요청
    func deleteRelation(id: Int) -> AnyPublisher<BaseResponse<BlankData>, PillinTimeError> {
        return provider.requestPublisher(.deleteRelation(id))
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
