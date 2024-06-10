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
    let medicineSeries: String
    let medicineCode: String
    let medicineImage: String
    let medicineEffect, useMethod, useWarning, useSideEffect: String
    let depositMethod: String
    let medicineAdverse: MedicineAdverse
}
