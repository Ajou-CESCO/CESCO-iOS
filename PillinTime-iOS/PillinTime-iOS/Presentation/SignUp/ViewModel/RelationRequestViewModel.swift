//
//  RelationRequestViewModel.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 5/25/24.
//

import SwiftUI
import Combine

import Factory

struct RelationRequestState {
    var failMessage: String = String()
}

class RelationRequestViewModel: ObservableObject {
    
    // MARK: - Dependency

    @Injected(\.requestServie) var requestService: RequestServiceType
    @Injected(\.relationService) var relationService: RelationServiceType
    @ObservedObject var toastManager = Container.shared.toastManager.resolve()
    
    // MARK: - Input State
    @Subject var requestRelationRequestList: Void = ()
    @Subject var requestCreateRelation: Int = Int()

    // MARK: - Output State
    @Subject var relationRequestState: RelationRequestState = RelationRequestState()
    @Published var relationRequestList: [RelationRequestListResponseModelResult] = []
    
    // MARK: - Other Data
    
    @Published var isNetworking: Bool = false
    @Published var isNetworkSucceed: Bool = false
    @Published var isCreateRelationSucced: Bool = false

    // MARK: - Cancellable Bag
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Constructor
    init(requestService: RequestServiceType, relationService: RelationServiceType) {
        self.requestService = requestService
        self.relationService = relationService
        bindState()
    }
    
    // MARK: - Bind Method
    
    private func bindState() {
        $requestRelationRequestList.sink { [weak self] in
            self?.requestRelationRequestListToServer()
        }
        .store(in: &cancellables)
        
        $requestCreateRelation.sink { [weak self] memberID in
            self?.requestCreateRelation(id: memberID)
        }
        .store(in: &cancellables)
    }
    
    // MARK: - Request Method
    
    func requestRelationRequestListToServer() {
        print("보호 관계 요청 리스트 조회 시작")
        self.isNetworking = true
        requestService.relationRequestList()
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                self.isNetworking = false
                switch completion {
                case .finished:
                    print("보호 관계 요청 리스트 조회 요청 완료")
                case .failure(let error):
                    print("보호 관계 요청 리스트 조회 실패: \(error)")
                    self.relationRequestState.failMessage = error.localizedDescription
                    toastManager.showNetworkFailureToast()
                }
            }, receiveValue: { [weak self] result in
                print("보호 관계 요청 리스트 조회 성공: ", result)
                guard let self = self else { return }
                self.relationRequestList = result.result
                
            })
            .store(in: &cancellables)
    }
    
    func requestCreateRelation(id: Int) {
        print("보호 관계 생성 시작")
        self.relationRequestState.failMessage = ""
        self.isNetworking = true
        relationService.createRelation(id: id)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                self.isNetworking = false
                switch completion {
                case .finished:
                    print("보호 관계 생성 요청 완료")
                    self.relationRequestState.failMessage = ""
                case .failure(let error):
                    print("보호 관계 생성 실패: \(error)")
                    self.relationRequestState.failMessage = error.description
                }
            }, receiveValue: { [weak self] result in
                guard let self = self else { return }
                print("보호 관계 생성 성공: ", result)
                self.isCreateRelationSucced = true
                self.toastManager.showToast(description: "보호 관계 생성을 완료했어요.")
            })
            .store(in: &cancellables)
    }
}
