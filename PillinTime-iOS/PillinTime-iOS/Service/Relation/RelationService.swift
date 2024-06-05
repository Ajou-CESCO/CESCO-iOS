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

class RelationService: RelationServiceType {
    let provider: MoyaProvider<RelationAPI>
    var cancellables = Set<AnyCancellable>()
    
    init(provider: MoyaProvider<RelationAPI>, cancellables: Set<AnyCancellable> = Set<AnyCancellable>()) {
        self.provider = provider
        self.cancellables = cancellables
    }
    
    // 보호관계 생성 요청
    func createRelation(id: Int) -> AnyPublisher<BaseResponse<BlankData>, PillinTimeError> {
        return provider.requestPublisher(.createRelation(id))
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
