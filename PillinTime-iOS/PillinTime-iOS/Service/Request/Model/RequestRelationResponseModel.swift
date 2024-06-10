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
    let result: RequestRelationResponseModelResult?
}

// MARK: - RequestRelationResponseModelResult

struct RequestRelationResponseModelResult: Codable {
    let id: Int
    let sender: RequestRelationSender
    let receiverPhone: String
}

// MARK: - Sender
struct RequestRelationSender: Codable {
    let id: Int
    let name, ssn, phone: String
    let gender: Int
    let fcmToken: String
    let cabinet: JSONNull?
    let manager, subscriber: Bool
}

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}

