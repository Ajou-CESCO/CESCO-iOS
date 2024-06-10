//
//  CreatePillCaseRequestModel.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 5/12/24.
//

import Foundation

// MARK: - CreatePillCaseRequestModel

struct CreatePillCaseRequestModel: Codable {
    let serial: String
    let ownerID: Int

    enum CodingKeys: String, CodingKey {
        case serial
        case ownerID = "ownerId"
    }
}
