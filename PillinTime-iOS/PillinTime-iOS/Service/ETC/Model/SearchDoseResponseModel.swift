//
//  SearchDoseResponseModel.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 5/12/24.
//

import Foundation

// MARK: - SearchDoseResponseModel

struct SearchDoseResponseModel: Codable {
    let status: Int
    let message: String
    let result: [SearchDoseResponseModelResult]
}

// MARK: - SearchDoseResponseModelResult

struct SearchDoseResponseModelResult: Codable {
    let companyName, medicineName: String
    let medicineAdverse: JSONNull?
    let medicineCode: String
    let medicineImage: String
    let medicineEffect, useMethod, useWarning, useSideEffect: String
    let depositMethod: String
    let adverseMap: AdverseMap
}

// MARK: - AdverseMap
struct AdverseMap: Codable {
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
            pregnancyContraindication,
            duplicateEfficacyGroup
        ].compactMap { $0 }
    }
}
