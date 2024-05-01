//
//  SignUpResponseModel.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 4/30/24.
//

import Foundation

struct SignUpResponseModel: Codable {
    let status: Int
    let message: String
    let result: SignUpResponseModelResult
}

// MARK: - Result
struct SignUpResponseModelResult: Codable {
    let accessToken: String

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
    }
}
