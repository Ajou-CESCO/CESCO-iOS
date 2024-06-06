//
//  InitResponseModel.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 5/15/24.
//

import Foundation

// MARK: - InitResponseModel

struct InitResponseModel: Codable {
    let status: Int
    let message: String
    let result: InitResponseModelResult
}

// MARK: - InitResponseModelResult

struct InitResponseModelResult: Codable {
    let memberID: Int
    let name, ssn, phone: String
    let gender, cabinetID: Int
    let isManager, isSubscriber: Bool
    let relationList: [RelationList]

    enum CodingKeys: String, CodingKey {
        case memberID = "memberId"
        case name, ssn, phone, gender
        case cabinetID = "cabinetId"
        case isManager, isSubscriber, relationList
    }
}

// MARK: - RelationList

struct RelationList: Codable {
    let id, memberID: Int
    let memberName, memberSsn, memberPhone: String
    let cabinetID: Int
    let cabinetIndexList: [Int]

    enum CodingKeys: String, CodingKey {
        case id
        case memberID = "memberId"
        case memberName, memberSsn, memberPhone
        case cabinetID = "cabinetId"
        case cabinetIndexList
    }
}
