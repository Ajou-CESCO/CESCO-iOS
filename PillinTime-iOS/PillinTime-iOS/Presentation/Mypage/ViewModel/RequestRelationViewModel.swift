//
//  RequestRelationViewModel.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 5/15/24.
//

import Foundation
import Combine

import Factory

struct RequestRelationState {
    var failMessage: String = String()
}

class RequestRelationViewModel: ObservableObject {
    
    // MARK: - Dependency
    
    @Injected(\.requestServie) var requestService: RequestServiceType

    // MARK: - Input State
    
    @Subject var tapRequestButton: String = String()

    // MARK: - Output State

    @Published var requestRelationState: RequestRelationState = RequestRelationState()
    @Published var requestRelationResult: RequestRelationResponseModelResult?
    @Published var isNetworking: Bool = false
    @Published var isNetworkSucceed: Bool = false

    // MARK: - Cancellable Bag
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Constructor
    
    init(requestService: RequestService) {
        self.requestService = requestService
        bindState()
    }
    
    // MARK: - Bind Method
    
    private func bindState() {
        $tapRequestButton.sink { [weak self] receiverPhone in
            self?.requestRelation(receiverPhone)
        }
        .store(in: &cancellables)
    }
    
    // MARK: - Request Method
    
    func requestRelation(_ receiverPhone: String) {
        print("보호관계 요청 시작: \(receiverPhone)")
        self.isNetworking = true
        requestService.relationRequest(receiverPhone: receiverPhone)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                switch completion {
                case .finished:
                    print("보호관계 요청 완료")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        self.isNetworking = false
                        self.isNetworkSucceed = true
                    }
                case .failure(let error):
                    print("보호관계 요청 실패: \(error)")
                    self.isNetworking = false
                    self.requestRelationState.failMessage = error.localizedDescription
                }
            }, receiveValue: { [weak self] result in
                guard let self = self else { return }
                self.requestRelationResult = result.result
            })
            .store(in: &cancellables)
    }
}
