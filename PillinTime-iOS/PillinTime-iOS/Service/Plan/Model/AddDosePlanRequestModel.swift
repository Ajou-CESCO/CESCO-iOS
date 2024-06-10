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
    let medicineID, medicineName, medicineSeries: String
    let medicineAdverse: MedicineAdverse
    let cabinetIndex: Int
    let weekdayList: [Int]
    let timeList: [String]
    let startAt: String
    let endAt: String

    enum CodingKeys: String, CodingKey {
        case memberID = "memberId"
        case medicineID = "medicineId"
        case medicineName, medicineSeries, medicineAdverse, cabinetIndex, weekdayList, timeList, startAt, endAt
    }
}

// MARK: - MedicineAdverse

struct MedicineAdverse: Codable {
    let dosageCaution, ageSpecificContraindication, elderlyCaution, administrationPeriodCaution, pregnancyContraindication, duplicateEfficacyGroup: String?
    
    enum CodingKeys: String, CodingKey {
        case dosageCaution = "용량주의"
        case ageSpecificContraindication = "특정연령대금기"
        case elderlyCaution = "노인주의"
        case administrationPeriodCaution = "투여기간주의"
        case pregnancyContraindication = "임부금기"
        case duplicateEfficacyGroup = "효능군중복"
    }
    
    func nonNilValues() -> [String] {
        return [
            dosageCaution,
            ageSpecificContraindication,
            elderlyCaution,
            administrationPeriodCaution,
            pregnancyContraindication
        ].compactMap { $0 }
    }
}
