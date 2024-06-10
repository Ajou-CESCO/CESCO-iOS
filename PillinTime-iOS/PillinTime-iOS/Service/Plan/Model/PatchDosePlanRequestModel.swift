//
//  PatchDosePlanRequestModel.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 6/10/24.
//

import Foundation

// MARK: - PatchDosePlanRequestModel
struct PatchDosePlanRequestModel: Codable {
    let groupID, memberID: Int
    let medicineID, medicineName, medicineSeries: String
    let medicineAdverse: MedicineAdverse
    let cabinetIndex: Int
    let weekdayList: [Int]
    let timeList: [String]
    let startAt: String

    enum CodingKeys: String, CodingKey {
        case groupID = "groupId"
        case memberID = "memberId"
        case medicineID = "medicineId"
        case medicineName, medicineSeries, medicineAdverse, cabinetIndex, weekdayList, timeList, startAt
    }
}
