//
//  AuthError.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 4/12/24.
//

import Foundation

/// Auth API Error
enum AuthError: Error {
    /// Auth API Signup Error
    case signup(_: SignupError)
    /// Auth API Phone Number Verification Error
    case phoneNumberVerificationError(_: PhoneNumberVerificationError)
    /// Auth API Login Error
    case login(_: LoginError)
    
    var description: String {
        switch self {
        case .signup(let error):
            return error.description
        case .phoneNumberVerificationError(let error):
            return error.description
        case .login(let error):
            return error.description
        }
    }
}

extension AuthError {
    enum SignupError: Error {
        case signupFailed
        case phoneNumberDuplicated
        
        var description: String {
            switch self {
            case .signupFailed:
                return "예상치 못한 원인으로 회원가입에 실패하였습니다."
            case .phoneNumberDuplicated:
                return "중복된 전화번호입니다."
            }
        }
    }
    
    enum PhoneNumberVerificationError: Error {
        case sendPhoneNumberConfirmFailed
        
        var description: String {
            switch self {
            case .sendPhoneNumberConfirmFailed:
                return "전화번호 인증 전송에 실패했습니다. 다시 시도해주세요."
            }
        }
    }
    
    enum LoginError: Error {
        case userNotFound
        case loginFailed
        
        var description: String {
            switch self {
            case .userNotFound:
                return "존재하지 않는 회원입니다."
            case .loginFailed:
                return "예상치 못한 원인으로 회원가입에 실패하였습니다."
            }
        }
    }
    
    enum CancelMembershipError: Error {
        case otherError
        
        var description: String {
            switch self {
            case .otherError:
                return "알 수 없는 오류가 발생했습니다."
            }
        }
    }
}

extension AuthError: Equatable {
    static func == (lhs: AuthError, rhs: AuthError) -> Bool {
        switch (lhs, rhs) {
        case (.signup(let lhsError), .signup(let rhsError)):
            return lhsError.localizedDescription == rhsError.localizedDescription
        case (.phoneNumberVerificationError(let lhsError), .phoneNumberVerificationError(let rhsError)):
            return lhsError.localizedDescription == rhsError.localizedDescription
        case (.login(let lhsError), .login(let rhsError)):
            return lhsError.localizedDescription == rhsError.localizedDescription
        default:
            return false
        }
    }
}

