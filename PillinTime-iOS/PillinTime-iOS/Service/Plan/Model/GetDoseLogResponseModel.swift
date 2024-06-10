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
    let result: GetDoseLogResponseModelResult
}

// MARK: - GetDoseLogResponseModelResult
struct GetDoseLogResponseModelResult: Codable {
    let cabinetIndexList: [Int]
    let logList: [LogList]
}

// MARK: - LogList
struct LogList: Codable {
    let id, memberID: Int
    let plannedAt: String
    let cabinetIndex: Int
    let medicineName: String
    let takenStatus: Int
    let medicineId: String

    enum CodingKeys: String, CodingKey {
        case id
        case memberID = "memberId"
        case plannedAt, cabinetIndex, medicineName, takenStatus, medicineId
    }
}
