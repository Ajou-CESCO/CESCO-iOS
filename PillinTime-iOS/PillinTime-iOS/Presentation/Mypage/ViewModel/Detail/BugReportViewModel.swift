//
//  BugReportViewModel.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 6/4/24.
//

import Foundation
import Combine
import SwiftUI
import Factory

// MARK: - BugReportViewModel

class BugReportViewModel: ObservableObject {
    
    // MARK: - Dependency
    
    @Injected(\.etcService) var etcService: EtcServiceType
    @ObservedObject var toastManager = Container.shared.toastManager.resolve()
    
    // MARK: - Input State

    @Subject var tapSubmitReport: String = String()
    
    // MARK: - Output State
    
    @Published var isNetworking: Bool = false
    @Published var isNetworkSucceed: Bool = false
    
    // MARK: - Other Data

    // MARK: - Cancellable Bag
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initializer
    
    init(etcService: EtcService) {
        self.etcService = etcService
        self.bindState()
    }
    
    // MARK: - Methods
    
    private func bindState() {
        /// 버그 리포트 등록 요청
        $tapSubmitReport.sink { [weak self] body in
            self?.requestBugReport(body)
        }
        .store(in: &cancellables)
    }
    
    // MARK: - Request Methods
    
    func requestBugReport(_ body: String) {
        print("버그 리포트 요청 시작")
        self.isNetworking = true
        etcService.bugReport(body: body)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                switch completion {
                case .finished:
                    print("버그 리포트 요청 완료")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        self.isNetworking = false
                        self.isNetworkSucceed = true
                        self.toastManager.showToast(description: "소중한 의견 주셔서 감사합니다.")
                    }
                case .failure(let error):
                    print("버그 리포트 요청 실패: \(error)")
                    self.isNetworking = false
                    toastManager.showToast(description: "요청을 실패했습니다.")
                }
            }, receiveValue: { [weak self] result in
                guard let result = self else { return }
                print(result)
            })
            .store(in: &cancellables)
    }
}
