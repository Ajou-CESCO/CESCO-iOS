//
//  GetDosePlanResponseModel.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 5/16/24.
//

import Foundation

// MARK: - GetDoseLogResponseModel

struct GetDoseLogResponseModel: Codable {
    let status: Int
    let message: String
    let result: [GetDoseLogResponseModelResult]
}

// MARK: - GetDoseLogResponseModelResult

struct GetDoseLogResponseModelResult: Codable {
    var id, memberID, planID: Int
    var plannedAt, medicineName: String
    var takenStatus: Int
    var cabinetIndex: Int

    enum CodingKeys: String, CodingKey {
        case id
        case memberID = "memberId"
        case planID = "planId"
        case plannedAt, medicineName, takenStatus, cabinetIndex
    }
}
