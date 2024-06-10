//
//  UserError.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 4/18/24.
//

import Foundation

enum UserError: Error {
    /// User API createUser Error
    case createUser(_: CreateUserError)
    /// User API getUserById Error
    case getUserById(_: GetUserByIdError)
//    /// User API getUserList Error
//    case getUserList(_: GetUserListError)
//    /// User API updateUserById Error
//    case updateUserById(_: UpdateUserById)
//    /// User API deleteUserById Error
//    case deleteUserById(_: DeleteUserById)
    
    var description: String {
        switch self {
        case .createUser(let error):
            return error.description
        case .getUserById(let error):
            return error.description
        }
    }
}

extension UserError {
    enum CreateUserError: Error {
        case signupFailed
        case userDuplicated
        
        var description: String {
            switch self {
            case .signupFailed:
                return "회원가입에 실패하였습니다."
            case .userDuplicated:
                return "이미 존재하는 사용자입니다."
            }
        }
    }
    
    enum GetUserByIdError: Error {
        case unauthorizedUserAccess
        case uuidNotFound
        
        var description: String {
            switch self {
            case .unauthorizedUserAccess:
                return "접근 권한이 없는 사용자입니다."
            case .uuidNotFound:
                return "일치하지 않는 사용자입니다."
            }
        }
    }
}

extension UserError: Equatable {
    static func == (lhs: UserError, rhs: UserError) -> Bool {
        switch (lhs, rhs) {
        case (.createUser(let lhsError), .createUser(let rhsError)):
            return lhsError.localizedDescription == rhsError.localizedDescription
        case (.getUserById(let lhsError), .getUserById(let rhsError)):
            return lhsError.localizedDescription == rhsError.localizedDescription
        default:
            return false
        }
    }
}
