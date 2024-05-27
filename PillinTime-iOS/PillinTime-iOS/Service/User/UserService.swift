//
//  UserService.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 4/18/24.
//

import Foundation
import Moya
import CombineMoya
import Combine

class UserService: UserServiceType {
    
    let provider: MoyaProvider<UserAPI>
    var cancellables = Set<AnyCancellable>()
    
    init(provider: MoyaProvider<UserAPI>, cancellables: Set<AnyCancellable> = Set<AnyCancellable>()) {
        self.provider = provider
        self.cancellables = cancellables
    }
    

    func createUser(createUserModel: CreateUserRequestModel) -> Bool {
        return true
    }
    
    func getUserById(uuid: String) -> Bool {
        return true
    }
    
    func getUserList() -> Bool {
        return true
    }
    
    func updateUserById(uuid: String) -> Bool {
        return true
    }

    /// 회원 탈퇴 요청
    func deleteUser() -> AnyPublisher<BaseResponse<BlankData>, PillinTimeError> {
        return provider.requestPublisher(.deleteUser)
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
