//
//  HKQuentitySample+Extension.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 6/3/24.
//

import Foundation
import HealthKit

extension HKQuantitySample {
    var asHeartRateEntity: HKHeartRateEntity {
        HKHeartRateEntity(
            startDate: self.startDate,
            endDate: self.endDate,
            quantity: self.quantity.doubleValue(
                for: HKUnit(from: "count/min")
            )
        )
    }
}
