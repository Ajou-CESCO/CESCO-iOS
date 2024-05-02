//
//  SignInResponseModel.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 5/1/24.
//

import Foundation

struct SignInResponseModel: Codable {
    let status: Int
    let message: String
    let result: SignInResponseModelResult
}

// MARK: - SignInResponseModelResult
struct SignInResponseModelResult: Codable {
    let accessToken: String

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
    }
}
