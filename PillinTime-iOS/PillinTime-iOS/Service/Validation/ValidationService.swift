//
//  ValidationService.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 4/11/24.
//

import Foundation

class ValidationService: ValidationServiceType {
    func isValidPhoneNumberFormat(_ phoneNumber: String) -> Bool {
        // 전화번호 정규식
        let phoneRegex = "^01[0-1,7]-?[0-9]{3,4}-?[0-9]{4}$"   // 하이픈이 있을수도, 없을수도 있는 경우 고려
        let predicate = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return predicate.evaluate(with: phoneNumber)
    }
}
