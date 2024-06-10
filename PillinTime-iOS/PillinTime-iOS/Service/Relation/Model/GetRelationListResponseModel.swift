//
//  GetRelationListResponseModel.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 5/26/24.
//

import Foundation

// MARK: - GetRelationListResponseModel
struct GetRelationListResponseModel: Codable {
    let status: Int
    let message: String
    let result: [GetRelationListResponseModelResult]
}

// MARK: - GetRelationListResponseModelResult
struct GetRelationListResponseModelResult: Codable {
    let id, memberID: Int
    let memberName, memberSsn, memberPhone: String
    let cabinetID: Int

    enum CodingKeys: String, CodingKey {
        case id
        case memberID = "memberId"
        case memberName, memberSsn, memberPhone
        case cabinetID = "cabinetId"
    }
}
