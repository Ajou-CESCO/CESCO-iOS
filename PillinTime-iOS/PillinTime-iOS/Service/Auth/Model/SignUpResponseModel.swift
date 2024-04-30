//
//  SignUpResponseModel.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 4/30/24.
//

import Foundation

struct SignUpResponseModel: Codable {
    let status: Int
    let message: String?
    let data: DataClass?
}

// MARK: - DataClass
struct DataClass: Codable {
}
