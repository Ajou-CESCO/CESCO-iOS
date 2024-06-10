//
//  LogoutViewModel.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 6/10/24.
//

import Foundation
import Combine
import SwiftUI
import Factory

// MARK: - LogoutViewModel

class LogoutViewModel: ObservableObject {
    
    // MARK: - Dependency
    
    @Injected(\.authService) var authService: AuthServiceType
    @ObservedObject var toastManager = Container.shared.toastManager.resolve()
    
    // MARK: - Input State

    @Subject var requestLogout: Void = ()
    
    // MARK: - Output State
    
    @Published var isLogoutSucced: Bool = false
        
    // MARK: - Other Data

    // MARK: - Cancellable Bag
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initializer
    
    init(authService: AuthServiceType) {
        self.authService = authService
        self.bindState()
    }
    
    // MARK: - Methods
    
    private func bindState() {
        $requestLogout.sink { [weak self] in
            self?.requestLogoutToServer()
        }
        .store(in: &cancellables)
    }
    
    // MARK: - Request Methods
    
    func requestLogoutToServer() {
        print("로그아웃 요청 시작")
        authService.logout()
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                switch completion {
                case .finished:
                    print("로그아웃 요청 완료")
                    self.isLogoutSucced = true
                case .failure(let error):
                    print("로그아웃 요청 실패: \(error)")
                    toastManager.showToast(description: "요청을 실패했습니다.")
                }
            }, receiveValue: { [weak self] result in
                guard let result = self else { return }
            })
            .store(in: &cancellables)
    }
}
