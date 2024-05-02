//
//  TodayDoseLogModel.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 4/15/24.
//

import Foundation

// 명세 확정 이후에 수정할 것
struct TodayDoseLogModel: Hashable {
    var pillName: String
    var doseTime: String
    var doseStatus: DoseStatus
}
