//
//  FcmViewModel.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 5/26/24.
//

import Foundation
import Combine

import Factory

struct FcmState {
    var failMessage: String = String()
}

class FcmViewModel: ObservableObject {
    
    // MARK: - Dependency
    
    @Injected(\.fcmService) var fcmService: FcmServiceType
    
    // MARK: - Input State
    
    @Subject var requestRegisterToken: String = String()
    @Subject var requestPushAlarm: Int = Int()

    // MARK: - Output State
    
    @Published var fcmState: FcmState = FcmState()
    @Published var isNetworking: Bool = false
    @Published var isNetworkSucceed: Bool = false
    
    // MARK: - Cancellable Bag
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Constructor
    
    init(fcmService: FcmService) {
        self.fcmService = fcmService
        bindState()
    }
    
    // MARK: - Bind Method
    
    private func bindState() {
        $requestRegisterToken.sink { [weak self] token in
            self?.requestRegisterTokenToServer(token)
        }
        .store(in: &cancellables)
        
        $requestPushAlarm.sink { [weak self] id in
            self?.requestPushAlarmToServer(id)
        }
        .store(in: &cancellables)
    }
    
    // MARK: - Request Method
    
    func requestRegisterTokenToServer(_ token: String) {
        print("토큰 등록 요청 시작: \(token)")
        self.isNetworkSucceed = false
        self.isNetworking = true
        fcmService.registerToken(fcmToken: token)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                self.isNetworking = false
                switch completion {
                case .finished:
                    print("토큰 등록 요청 완료")
                case .failure(let error):
                    print("토큰 등록 요청 실패: \(error)")
                    self.isNetworkSucceed = false
                    self.fcmState.failMessage = error.localizedDescription
                }
            }, receiveValue: { [weak self] result in
                guard let self = self else { return }
                self.isNetworkSucceed = true
            })
            .store(in: &cancellables)
    }
    
    func requestPushAlarmToServer(_ id: Int) {
        print("푸시 알림 요청 시작: \(id)")
        self.isNetworkSucceed = false
        self.isNetworking = true
        fcmService.requestPushAlarm(targetId: id)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                self.isNetworking = false
                switch completion {
                case .finished:
                    print("푸시 알림 요청 완료")
                case .failure(let error):
                    print("푸시 알림 요청 실패: \(error)")
                    self.isNetworkSucceed = false
                    self.fcmState.failMessage = error.localizedDescription
                }
            }, receiveValue: { [weak self] result in
                guard let self = self else { return }
                self.isNetworkSucceed = true
            })
            .store(in: &cancellables)
    }
}
