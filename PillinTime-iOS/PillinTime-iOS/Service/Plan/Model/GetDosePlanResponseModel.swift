//
//  GetDosePlanResponseModel.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 5/26/24.
//

import Foundation

// MARK: - GetDosePlanResponseModel
struct GetDosePlanResponseModel: Codable {
    let status: Int
    let message: String
    let result: [GetDosePlanResponseModelResult]
}

// MARK: - GetDosePlanResponseModelResult
struct GetDosePlanResponseModelResult: Codable, Identifiable {
    let id = UUID()  
    let groupId: Int
    let medicineID, medicineName: String
    let cabinetIndex: Int
    let weekdayList: [Int]
    let timeList: [String]
    let startAt, endAt: String
    let medicineAdverse: MedicineAdverse

    enum CodingKeys: String, CodingKey {
        case medicineID = "medicineId"
        case medicineName, cabinetIndex, weekdayList, timeList, startAt, endAt, medicineAdverse, groupId
    }
}
