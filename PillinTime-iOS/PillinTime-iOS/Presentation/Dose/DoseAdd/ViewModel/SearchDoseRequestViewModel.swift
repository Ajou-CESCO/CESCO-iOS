//
//  SearchDoseRequestViewModel.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 5/12/24.
//

import Foundation
import Combine

import Factory

struct SearchDoseState {
    var failMessage: String = String()
}

class SearchDoseRequestViewModel: ObservableObject {
    
    // MARK: - Dependency
    
    @Injected(\.etcService) var etcService: EtcServiceType
    
    // MARK: - Input State
    
    @Published var searchDose: String = String()
    @Subject var tapSearchButton: String = String()
    
    // MARK: - Output State
    
    @Published var searchDoseState: SearchDoseState = SearchDoseState()
    @Published var searchResults: [SearchDoseResponseModelResult] = []
    @Published var isNetworking: Bool = false
    @Published var isNetworkSucceed: Bool = false
    @Published var isResultEmpty: Bool = false
    
    // MARK: - Cancellable Bag
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Constructor
    
    init(etcService: EtcService) {
        self.etcService = etcService
        bindState()
    }
    
    // MARK: - Bind Method
    
    private func bindState() {
        $tapSearchButton.sink { [weak self] name in
            self?.requestSearchDose(name)
        }
        .store(in: &cancellables)
    }
    
    // MARK: - Request Method
    
    func requestSearchDose(_ name: String) {
        print("약물 검색 요청 시작: \(name)")
        self.isNetworkSucceed = false
        self.isResultEmpty = false
        self.isNetworking = true
        etcService.searchDose(name: name.trimmingCharacters(in: [" "]))
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                self.isNetworking = false
                switch completion {
                case .finished:
                    print("약물 검색 요청 완료")
                case .failure(let error):
                    print("약물 검색 요청 실패: \(error)")
                    self.isNetworkSucceed = false
                    self.isResultEmpty = true
                    self.searchDoseState.failMessage = error.localizedDescription
                }
            }, receiveValue: { [weak self] result in
                guard let self = self else { return }
                self.isNetworkSucceed = true
                self.searchResults = result.result  // 검색 결과 업데이트
                if result.result.isEmpty { self.isResultEmpty = true }
            })
            .store(in: &cancellables)
    }
}
