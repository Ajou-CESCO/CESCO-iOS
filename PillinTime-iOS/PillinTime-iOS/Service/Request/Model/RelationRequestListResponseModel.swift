//
//  RequestRelationRequestListModel.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 5/25/24.
//

import Foundation

// MARK: - RelationRequestListResponseModel

struct RelationRequestListResponseModel: Codable {
    let status: Int
    let message: String
    let result: [RelationRequestListResponseModelResult]
}

// MARK: - RelationRequestListResponseModelResult

struct RelationRequestListResponseModelResult: Codable {
    let id, senderID: Int
    let senderName, senderPhone, receiverPhone: String

    enum CodingKeys: String, CodingKey {
        case id
        case senderID = "senderId"
        case senderName, senderPhone, receiverPhone
    }
}
