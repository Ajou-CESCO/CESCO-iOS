//
//  AddDosePlanRequestModel.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 5/12/24.
//

import Foundation

struct AddDosePlanRequestModel: Encodable {
    var memberId: Int = 0
    var medicineId: String = ""
    var weekday: [Int] = []
    var time: [Int] = []
}
