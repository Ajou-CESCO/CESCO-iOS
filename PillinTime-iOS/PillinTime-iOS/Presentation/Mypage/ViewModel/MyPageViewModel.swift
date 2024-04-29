//
//  MyPageViewModel.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 4/25/24.
//

import Combine

@frozen
enum SettingListElement {
    case managementMyInformation
    case subscriptionPaymentHistory
    case customerServiceCenter
    case withdrawal

    var description: String {
        switch self {
        case .managementMyInformation:
            return "내 정보 관리"
        case .subscriptionPaymentHistory:
            return "구독 결제 내역"
        case .customerServiceCenter:
            return "고객 센터"
        case .withdrawal:
            return "회원 탈퇴"
        }
    }
    
    static let allCases: [SettingListElement] = [
        .managementMyInformation,
        .subscriptionPaymentHistory,
        .customerServiceCenter,
        .withdrawal
    ]
}

class MyPageViewModel: ObservableObject {
    
    // MARK: - Properties

    @Published var settingListElement: SettingListElement?
    @Published var user: CreateUserRequestModel?
    
    // MARK: - Initializer
    
    init() {
        mockUser()
    }
    
    func mockUser() {
        self.user = CreateUserRequestModel(name: "이재영", phoneNumber: "010-0000-0000", ssn: "021225-4", userType: 0)
    }
}
