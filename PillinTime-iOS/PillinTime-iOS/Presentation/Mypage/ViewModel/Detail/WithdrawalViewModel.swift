//
//  WithdrawalViewModel.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 5/27/24.
//

import SwiftUI
import Combine

import Factory

struct WithdrawalViewModelState {
    var failMessage: String = String()
}

class WithdrawalViewModel: ObservableObject {
    
    // MARK: - Dependency
    
    @Injected(\.userService) var userService: UserServiceType
    
    // MARK: - Input State
    
    @Subject var requestDeleteUser: Void = ()
    
    // MARK: - Output State
    
    @Published var isNetworking: Bool = false
    @Published var isNetworkSucceed: Bool = false
    @Published var withdrawalViewModelState: WithdrawalViewModelState = WithdrawalViewModelState()
    
    // MARK: - Cancellable Bag
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Constructor
    
    init(userService: UserServiceType) {
        self.userService = userService
        bindState()
    }
    
    // MARK: - bind
    
    private func bindState() {
        $requestDeleteUser.sink { [weak self] in
            self?.requestDeleteUserToServer()
        }
        .store(in: &cancellables)
    }
    
    // MARK: - Request Method
    
    func requestDeleteUserToServer() {
        print("탈퇴 요청 시작")
        self.isNetworking = true
        userService.deleteUser()
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                self.isNetworking = false
                switch completion {
                case .finished:
                    print("탈퇴 요청 완료")
                case .failure(let error):
                    print("탈퇴 요청 실패: \(error)")
                    self.withdrawalViewModelState.failMessage = error.localizedDescription
                }
            }, receiveValue: { [weak self] result in
                print("탈퇴 성공: ", result)
                guard let self = self else { return }
                /// 탈퇴가 완료되면 토큰 삭제 / 화면 전환을 위한 알림
                UserManager.shared.accessToken = nil
                self.isNetworkSucceed = true
            })
            .store(in: &cancellables)
    }
}
