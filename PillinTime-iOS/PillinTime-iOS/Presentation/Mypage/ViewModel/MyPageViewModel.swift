//
//  MyPageViewModel.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 4/25/24.
//

import Combine
import Foundation

@frozen
enum SettingListElement: Identifiable {
    case managementMyInformation
    case subscriptionPaymentHistory
    case customerServiceCenter
    case withdrawal
    case clientManage
    case logout
    case managementDoseSchedule
    case todaysHealthState
    case bugReport
    
    var id: SettingListElement {
        return self
    }

    var description: String {
        switch self {
        case .managementMyInformation:
            return "내 정보 보기"
        case .subscriptionPaymentHistory:
            return "구독 결제 내역"
        case .customerServiceCenter:
            return "고객 센터"
        case .withdrawal:
            return "회원 탈퇴"
        case .clientManage:
            return "보호 관계 관리"
        case .logout:
            return "로그아웃"
        case .managementDoseSchedule:
            return "복약 일정 관리"
        case .todaysHealthState:
            return "오늘의 건강 상태"
        case .bugReport:
            return "버그 제출하기"
        }
    }
    
    var image: String {
        switch self {
        case .clientManage:
            return "ic_people"
        case .managementDoseSchedule:
            return "ic_schedule"
        default:
            return "ic_people"
        }
    }
    
    static let topCases: [SettingListElement] = [
        .clientManage,
        .managementDoseSchedule
    ]
    
    static let listCases: [SettingListElement] = [
        .managementMyInformation,
//        .subscriptionPaymentHistory,
//        .customerServiceCenter,
        .logout,
        .withdrawal,
        .bugReport
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
