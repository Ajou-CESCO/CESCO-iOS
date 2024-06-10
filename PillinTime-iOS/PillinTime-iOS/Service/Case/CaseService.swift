//
//  CaseService.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 5/12/24.
//

import Foundation
import Moya
import CombineMoya
import Combine

class CaseService: CaseServiceType {

    let provider: MoyaProvider<CaseAPI>
    var cancellables = Set<AnyCancellable>()
    
    init(provider: MoyaProvider<CaseAPI>,
         cancellables: Set<AnyCancellable> = Set<AnyCancellable>()) {
        self.provider = provider
        self.cancellables = cancellables
    }
    
    /// 약통 등록 요청
    func createPillCaseRequest(createPillCaseRequestModel: CreatePillCaseRequestModel) -> AnyPublisher<BaseResponse<BlankData>, PillinTimeError> {
        return provider.requestPublisher(.createCase(createPillCaseRequestModel))
            .tryMap { response in
                guard let httpResponse = response.response, 200..<300 ~= httpResponse.statusCode else {
                    print(response.response?.statusCode)
                    throw PillinTimeError.networkFail
                }
                
                do {
                    let baseResponse = try JSONDecoder().decode(BaseResponse<BlankData>.self, from: response.data)
                    if baseResponse.status != 200 {
                        throw PillinTimeError.networkFail
                    }
                    return baseResponse
                } catch {
                    throw PillinTimeError.networkFail
                }
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
    
    /// 약통 삭제 요청
    func deletePillCaseRequest(cabineId: Int) -> AnyPublisher<BaseResponse<BlankData>, PillinTimeError> {
        return provider.requestPublisher(.deleteCase(cabineId))
            .tryMap { response in
                guard let httpResponse = response.response, 200..<300 ~= httpResponse.statusCode else {
                    print(response.response?.statusCode)
                    throw PillinTimeError.networkFail
                }
                
                do {
                    let baseResponse = try JSONDecoder().decode(BaseResponse<BlankData>.self, from: response.data)
                    if baseResponse.status != 200 {
                        throw PillinTimeError.networkFail
                    }
                    return baseResponse
                } catch {
                    throw PillinTimeError.networkFail
                }
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
