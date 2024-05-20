//
//  SignUpRequestModel.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 4/30/24.
//

import Foundation

struct SignUpRequestModel: Encodable {
    let name, ssn, phone: String
    let isManager: Bool
}
