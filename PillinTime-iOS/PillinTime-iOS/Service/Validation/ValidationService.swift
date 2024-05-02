//
//  ValidationService.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 4/11/24.
//

import Foundation

class ValidationService: ValidationServiceType {
    func isValidNameFormat(_ name: String) -> Bool {
        // 이름 정규식
        let nameRegex = "^[가-힣a-zA-Z]{1,}"
        let nameTest = NSPredicate(format: "SELF MATCHES %@", nameRegex)
        return nameTest.evaluate(with: name)
    }
    
    func isValidSsnFormat(_ ssh: String) -> Bool {
        // 주민번호 정규식
        let sshRegax = "^[0-9]{6}-[1-4]●●●●●●$"
        let sshText = NSPredicate(format: "SELF MATCHES %@", sshRegax)
        return sshText.evaluate(with: ssh)
    }
    
    func isValidPhoneNumberFormat(_ phoneNumber: String) -> Bool {
        // 전화번호 정규식
        let phoneRegex = "^01[0-1,7]-?[0-9]{3,4}-?[0-9]{4}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return predicate.evaluate(with: phoneNumber)
    }
}
