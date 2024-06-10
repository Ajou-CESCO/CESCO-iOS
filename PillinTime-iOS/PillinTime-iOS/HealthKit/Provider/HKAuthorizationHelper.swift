//
//  HKAuthorizationHelper.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 5/21/24.
//

import Foundation
import HealthKit

/// HealthKit Authorization를 관리하는 클래스입니다.
/// Reference: https://dokit.tistory.com/29
class HKAuthorizationHelper {
    
    static let shared = HKAuthorizationHelper()
    
    private let healthStore = HKHealthStore()
    
    private init() { }
    
    // 읽기 및 쓰기 권한 설정
    /// 수면, 걸음수, 소모 칼로리
    let readAndShare = Set([HKCategoryType.categoryType(forIdentifier: .sleepAnalysis)!,
                            HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)!,
                            HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.activeEnergyBurned)!,
                            HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)!])
    
    func setAuthorization() {
        // 데이터 접근 가능 여부에 따라 권한 요청 메소드 호출
        if HKHealthStore.isHealthDataAvailable() && !checkAuthorizationStatus() {
            requestAuthorization()
        }
    }
    
    // 권한 요청 메소드
    private func requestAuthorization() {
        self.healthStore.requestAuthorization(toShare: readAndShare, read: readAndShare) { success, error in
            if error != nil {
                print(error.debugDescription)
            } else {
                if success {
                    print("권한이 허용되었습니다.")
                } else {
                    print("권한이 없습니다.")
                }
            }
        }
    }
    
    // 권한 허용 확인
    private func checkAuthorizationStatus() -> Bool {
        let sleepAnalysisType = HKCategoryType.categoryType(forIdentifier: .sleepAnalysis)!
        
        let authorizationStatus = healthStore.authorizationStatus(for: sleepAnalysisType)
        print(authorizationStatus.rawValue)

        switch authorizationStatus {
        case .notDetermined:
            // 권한이 아직 요청되지 않음
            return false
        case .sharingDenied:
            // 권한 거부됨
            return false
        case .sharingAuthorized:
            // 권한 부여됨
            return true
        default:
            return false
        }
    }
}
