//
//  HKServiceProtocol.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 5/21/24.
//

import Foundation
import Combine

/// HealthKit에서의 데이터 샘플을 가져오는 프로토콜입니다.
protocol HKServiceProtocol {
    
    /// 특정 날짜의 수면 시간(단위: 분)을 구합니다. (어제 오후 6시 ~ 오늘 오후 6시 사이)
    ///
    /// - Note: 수면 상태는 inbed로 설정합니다. (상태 구분 없이 총 수면 시간)
    ///
    /// - Parameters:
    ///     - date: 수면 데이터를 추출할 대상의 날짜입니다.
    /// - Returns: 총 시간을 Int(단위: 분)으로 반환합니다.
    func getSleepRecord(date: Date) -> AnyPublisher<Int, HKError>
    
    /// 특정 날짜의 걸음 수를 구합니다.
    ///
    /// - Parameters:
    ///     - date: 걸음 데이터를 추출할 대상의 날짜입니다.
    /// - Returns: 총 걸음수를 Double로 반환합니다.
    func getStepCount(date: Date) -> Future<Double, HKError>
    
    /// 특정 날짜의 소모 칼로리를 구합니다.
    ///
    /// - Parameters:
    ///     - date: 소모 칼로리 데이터 추출할 대상의 날짜입니다.
    /// - Returns: 총 소모 칼로리를 Double로 반환합니다.
    func getEnergy(date: Date) -> Future<Double, HKError>
    
    /// 특정 날짜의 심박동 정보를 구합니다.
    ///
    /// - Parameters:
    ///     - date: 심박동 데이터 추출할 대상의 날짜입니다.
    /// - Returns: 총 소모 칼로리를 Double로 반환합니다.
    func getHeartRate(date: Date) -> AnyPublisher<[Double], HKError>
}
