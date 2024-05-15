//
//  RelationRequest.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 5/15/24.
//

import Foundation

// MARK: - RequestRelationResponseModel

struct RequestRelationResponseModel: Codable {
    let status: Int
    let message: String
    let result: RequestRelationResponseModelResult
}

// MARK: - RequestRelationResponseModelResult

struct RequestRelationResponseModelResult: Codable {
    let id, senderID: Int
    let receiverPhone: String

    enum CodingKeys: String, CodingKey {
        case id
        case senderID = "senderId"
        case receiverPhone
    }
}
