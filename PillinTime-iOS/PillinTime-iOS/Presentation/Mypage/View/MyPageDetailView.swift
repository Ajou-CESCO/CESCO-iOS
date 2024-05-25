//
//  MyPageDetailView.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 4/15/24.
//

import SwiftUI

import LinkNavigator

// 이후 다른 곳으로 이동할 것
@frozen
enum UserProfile {
    case name
    case phoneNumber
    case ssn
    var description: String {
        switch self {
        case .name:
            return "성명"
        case .phoneNumber:
            return "휴대폰 번호"
        case .ssn:
            return "주민등록번호"
        }
    }
    static let allCases: [UserProfile] = [
        .name,
        .phoneNumber,
        .ssn
    ]
}

// MARK: - MyPageDetailView

struct MyPageDetailView: View {
    
    // MARK: - Properties
    
    @State var isEditing: Bool = false
    @State var settingListElement: SettingListElement
    
    let navigator: LinkNavigatorType
    
    init(navigator: LinkNavigatorType, settingListElement: SettingListElement) {
        self.navigator = navigator
        self.settingListElement = settingListElement
    }
    
    // MARK: - body
    
    var body: some View {
        
        VStack {
            CustomNavigationBar(title: settingListElement.description)
            
            switch settingListElement {
            case .managementMyInformation:
                ManagementMyInformationView(userInfo: SelectedRelation(name: UserManager.shared.name ?? "null", 
                                                                       ssn: UserManager.shared.ssn ?? "null",
                                                                       phone: UserManager.shared.phoneNumber ?? "null"))
            case .subscriptionPaymentHistory:
                SubscriptionPaymentHistoryView()
            case .customerServiceCenter:
                CustomerServiceCenterView()
            case .withdrawal:
                WithdrawalView()
            case .clientManage:
                ClientManageView()
            case .logout:
                LogoutView(navigator: navigator)
            }
            
            Spacer()
        }
        .navigationBarHidden(true)
    }
}

// MARK: - SubscriptionPaymentHistoryView

struct SubscriptionPaymentHistoryView: View {
    var body: some View {
        /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Hello, world!@*/Text("Hello, world!")/*@END_MENU_TOKEN@*/
    }
}

// MARK: - CustomerServiceCenterView

struct CustomerServiceCenterView: View {
    var body: some View {
        /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Hello, world!@*/Text("Hello, world!")/*@END_MENU_TOKEN@*/
    }
}

// MARK: - LogoutView

struct LogoutView: View {
    
    let navigator: LinkNavigatorType
    
    init(navigator: LinkNavigatorType) {
        self.navigator = navigator
    }

    var body: some View {
        Button(action: {
            // 액세스 토큰 삭제
            UserManager.shared.accessToken = nil
            navigator.next(paths: ["content"], items: [:], isAnimated: true)
        }, label: {
            Text("로구아웃 버튼 ㅋ.ㅋ")
        })
    }
}
