//
//  GetHealthDateResponseModel.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 6/3/24.
//

import Foundation

// MARK: - GetHealthDateResponseModel

struct GetHealthDateResponseModel: Codable {
    let status: Int
    let message: String
    let result: GetHealthDateResponseModelResult?
}

// MARK: - GetHealthDateResponseModelResult

struct GetHealthDateResponseModelResult: Codable {
    let id: Int?
    let ageGroup: Int?
    let steps: Int?
    let averStep: Int?
    let stepsMessage: String?
    let calorie: Int?
    let calorieMessage: String?
    let heartRate: Int?
    let heartRateMessage: String?
    let sleepTime: Int?
    let recommendSleepTime: Int?
    let sleepTimeMessage: String?
    
    var isEmpty: Bool {
        return id == nil &&
               ageGroup == nil &&
               steps == nil &&
               averStep == nil &&
               stepsMessage == nil &&
               calorie == nil &&
               calorieMessage == nil &&
               heartRate == nil &&
               heartRateMessage == nil &&
               sleepTime == nil &&
               recommendSleepTime == nil &&
               sleepTimeMessage == nil
    }
}
