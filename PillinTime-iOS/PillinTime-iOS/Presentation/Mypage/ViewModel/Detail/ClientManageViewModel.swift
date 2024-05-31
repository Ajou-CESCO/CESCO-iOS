//
//  ClientManageViewModel.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 5/26/24.
//

import SwiftUI
import Combine

import Factory

struct GetRelationListState {
    var failMessage: String = String()
}

struct DeleteRelationState {
    var failMessage: String = String()
}

class ClientManageViewModel: ObservableObject {
    
    // MARK: - Dependency
    
    @Injected(\.relationService) var relationService: RelationServiceType
    @ObservedObject var toastManager = Container.shared.toastManager.resolve()
    
    // MARK: - Input State
    @Subject var requestGetRelationList: Void = ()
    @Subject var requestDeleteRelation: Int = Int()
    
    // MARK: - Output State
    @Subject var getRelationListState: GetRelationListState = GetRelationListState()
    @Subject var deleteRelationState: DeleteRelationState = DeleteRelationState()
    @Published var relationList: [GetRelationListResponseModelResult] = []
    
    // MARK: - Other Data
    
    @Published var isNetworking: Bool = false
    @Published var isNetworkSucceed: Bool = false
    @Published var isDeleteSucceed: Bool = false

    // MARK: - Cancellable Bag
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Constructor
    init(relationService: RelationServiceType) {
        self.relationService = relationService
        bindState()
    }
    
    // MARK: - Bind Method

    private func bindState() {
        $requestGetRelationList.sink { [weak self] in
            self?.requestGetRelationListToServer()
        }
        .store(in: &cancellables)
        
        $requestDeleteRelation.sink { [weak self] id in
            self?.requestDeleteRelationToServer(id: id)
        }
        .store(in: &cancellables)
    }
    
    // MARK: - Request Method
    
    func requestGetRelationListToServer() {
        print("보호 관계 리스트 조회 시작")
        self.isNetworking = true
        relationService.getRelationList()
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                self.isNetworking = false
                switch completion {
                case .finished:
                    print("보호 관계 리스트 조회 요청 완료")
                case .failure(let error):
                    print("보호 관계 리스트 조회 실패: \(error)")
                    self.getRelationListState.failMessage = error.localizedDescription
                    toastManager.showNetworkFailureToast()
                }
            }, receiveValue: { [weak self] result in
                print("보호 관계 리스트 조회 성공: ", result)
                guard let self = self else { return }
                self.relationList = result.result
                
            })
            .store(in: &cancellables)
    }
    
    func requestDeleteRelationToServer(id: Int) {
        print("보호 관계 삭제 시작")
        self.isNetworking = true
        relationService.deleteRelation(id: id)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                self.isNetworking = false
                switch completion {
                case .finished:
                    print("보호 관계 삭제 요청 완료")
                case .failure(let error):
                    print("보호 관계 삭제 실패: \(error)")
                    self.deleteRelationState.failMessage = error.localizedDescription
                    toastManager.showNetworkFailureToast()
                }
            }, receiveValue: { [weak self] result in
                print("보호 관계 삭제 성공: ", result)
                guard let self = self else { return }
                self.isDeleteSucceed = true
                self.toastManager.showToast(description: "보호 관계 삭제를 완료했어요.")
            })
            .store(in: &cancellables)
    }
}
