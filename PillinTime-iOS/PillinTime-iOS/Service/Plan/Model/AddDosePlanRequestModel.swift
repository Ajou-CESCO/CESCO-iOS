//
//  AddDosePlanRequestModel.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 5/12/24.
//

import Foundation

// MARK: - AddDosePlanRequestModel

struct AddDosePlanRequestModel: Codable {
    let memberID: Int
    let medicineID: String
    let weekdayList: [Int]
    let timeList: [String]
    let startAt, endAt: String
    let cabinetIndex: Int

    enum CodingKeys: String, CodingKey {
        case memberID = "memberId"
        case medicineID = "medicineId"
        case weekdayList, timeList, startAt, endAt, cabinetIndex
    }
}
