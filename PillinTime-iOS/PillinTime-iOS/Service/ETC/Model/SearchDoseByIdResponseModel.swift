//
//  SearchDoseByIdResponseModel.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 6/9/24.
//

import Foundation

// MARK: - SearchDoseByIdResponseModel

struct SearchDoseByIdResponseModel: Codable {
    let status: Int
    let message: String
    let result: SearchDoseResponseModelResult
}
