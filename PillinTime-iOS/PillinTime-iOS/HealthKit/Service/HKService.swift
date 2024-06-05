//
//  HKService.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 5/21/24.
//

import Foundation
import Combine
import HealthKit

class HKService: HKServiceProtocol {

    // MARK: - Properties

    var provider: HKProvider
    let dateHelper: DateHelper = DateHelper()
    private var core: HKSleepCore
    
    init(provider: HKProvider, core: HKSleepCore) {
        self.provider = provider
        self.core = core
    }
    
    // MARK: - Quary Methods
    
    /// 수면 시간
    func getSleepRecord(date: Date) -> AnyPublisher<Int, HKError> {
        return self.fetchSleepSamples(date: date)
            .tryMap { samples in
                print("samples:", samples)
                return self
                    .core
                    .calculateSleepTimeQuentity(
                        sleepType: .inbed,
                        samples: samples.map { $0.asSleepEntity }
                    ) ?? 0
            }
            .mapError { error in
                return error as! HKError
            }
            .eraseToAnyPublisher()
    }
    
    /// 심장박동수
    func getHeartRate(date: Date) -> AnyPublisher<[Double], HKError> {
        return self.fetchHeartRate(date: date)
            .map { samples in
                self.core.getHeartRateBPM(
                    samples: samples.map { $0.asHeartRateEntity}
                )
            }
            .eraseToAnyPublisher()
    }
    
    /// 걸음 수
    func getStepCount(date: Date) -> Future<Double, HKError> {
        return Future { promise in
            let startOfDay = self.startDate(date: date)
            let endOfDay = self.endDate(date: date)
            let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: endOfDay, options: .strictStartDate)

            self.provider.getQuantityTypeStatistics(identifier: .stepCount,
                                                    predicate: predicate) { result, error in
                if let error = error {
                    promise(.failure(HKError.providerFetchSamplesFailed(error: error)))
                    return
                }
                
                guard let sum = result?.sumQuantity() else {
                    promise(.failure(HKError.sumQuentityFailed))
                    return
                }
                
                let value = sum.doubleValue(for: .count())
                promise(Result.success(value))
                print("step:", value)
                print(result)
            }
        }
    }
    
    /// 소모 칼로리
    func getEnergy(date: Date) -> Future<Double, HKError> {
        return Future { promise in
            let startOfDay = self.startDate(date: date)
            let endOfDay = self.endDate(date: date)
            let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: endOfDay, options: .strictStartDate)
            self.provider.getQuantityTypeStatistics(identifier: .activeEnergyBurned,
                                                    predicate: predicate) { result, error in
                if let error = error {
                    promise(.failure(HKError.providerFetchSamplesFailed(error: error)))
                    return
                }
                
                guard let sum = result?.sumQuantity() else {
                    promise(.failure(HKError.sumQuentityFailed))
                    return
                }
                
                let value = sum.doubleValue(for: .kilocalorie())
                print("energy:", value)
                promise(Result.success(value))
                print(result)
            }
        }
    }
    
    // MARK: - Methods
    
    private func startDate(date: Date) -> Date? {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        components.hour = 0
        components.minute = 0
        components.second = 0
        
        let start = calendar.date(from: components)!
        
        return start
    }
    
    private func endDate(date: Date) -> Date? {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        components.hour = 23
        components.minute = 59
        components.second = 59
        
        let end = calendar.date(from: components)!
        
        return end
    }
}

extension HKService {
    /// 내부적으로 Healthkit Provider를 통해 데이터를 가져옵니다. 결과는 completion으로 전달합니다.
    ///
    /// - Parameters:
    ///    - date: 데이터를 가져오고자 하는 날짜를 주입합니다.
    ///    - completion: sample을 전달받는 콜백 클로저입니다.
    /// - Returns: 수면 데이터를 [HKCategorySample] 형으로 Future에 담아 반환합니다.
    private func fetchSleepSamples(date: Date) -> Future<[HKCategorySample], HKError> {
        return Future() { promise in

            if date > Date() {
                fatalError("Future dates are not accessible.")
            }
            
            // 조건 날짜 정의 (그날 오후 6시 - 다음날 오후 6시)
            let endDate = self.dateHelper.getTodaySixPM(date)
            let startDate = self.dateHelper.getYesterdaySixPM(date)
            let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate)
            
            // 수면 데이터 가져오기
            self.provider.getCategoryTypeSamples(identifier: .sleepAnalysis,
                                                 predicate: predicate) { samples, error  in
                if let error = error { promise(.failure(error)) }
                print("sample:", samples)
                promise(.success(samples))
            }
        }
    }
    
    /// 특정 시간의 심박수 fetch
    private func fetchHeartRate(date: Date)
    -> Future<[HKQuantitySample], HKError> {
        return Future { promise in
            let endDate = self.dateHelper.getYesterdayEndPM(date)
            let startDate = self.dateHelper.getYesterdayStartAM(date)
            let predicate = HKQuery.predicateForSamples(withStart: startDate,
                                                        end: endDate,
                                                        options: .strictEndDate)
            self.provider.getQuantityTypeSamples(identifier: .heartRate,
                                                 predicate: predicate) { samples, error in
                if let error = error {
                    promise(.failure(error))
                }
                promise(.success(samples))
                print("heartrate", samples)
                print("error", error)
            }
        }
    }
    
    /// 내부적으로 SleepModel을 생성합니다.
    /// - Parameter samples: 어제 오후 6시~ 오늘 오후 6시 사이의 모든 수면 데이터입니다.
    /// - Returns: 전반적인 수면 정보를 담은 HKSleepModel을 반환합니다.
    private func createSleepModel(samples: [HKCategorySample]) -> HKSleepModel {
        let sleepEntities = samples
            .map { $0.asSleepEntity }
        return HKSleepModel(
            inbedQuentity: self.core.calculateSleepTimeQuentity(
                sleepType: .inbed,
                samples: sleepEntities
            ) ?? 0,
            startTime: self.core.calculateSleepStartDate(
                samples: sleepEntities
            ),
            endTime: self.core.calculateSleepEndDate(
                samples: sleepEntities)
        )
    }
}
