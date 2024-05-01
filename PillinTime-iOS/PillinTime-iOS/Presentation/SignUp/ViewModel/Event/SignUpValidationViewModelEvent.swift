//
//  SignUpValidationViewModelEvent.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 4/11/24.
//

import Foundation

enum SignUpValidationViewModelEvent {
    case phoneNumberValid(phone: String)
    case phoneNumberInvalid
    case nameValid(name: String)
    case nameInvalid
    case ssnValid(ssn: String)
    case ssnInvalid
    case sendInfoForSignUp(info: InfoState)
    case sendInfoForSignIn(info: InfoState)
}
