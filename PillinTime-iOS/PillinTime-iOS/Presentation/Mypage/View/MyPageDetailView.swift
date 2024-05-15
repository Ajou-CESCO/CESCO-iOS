//
//  MyPageDetailView.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 4/15/24.
//

import SwiftUI

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
    
    // MARK: - body
    
    var body: some View {
        
        VStack {
            CustomNavigationBar(title: settingListElement.description)
            
            switch settingListElement {
            case .managementMyInformation:
                ManagementMyInformationView()
            case .subscriptionPaymentHistory:
                SubscriptionPaymentHistoryView()
            case .customerServiceCenter:
                CustomerServiceCenterView()
            case .withdrawal:
                WithdrawalView()
            case .clientManage:
                ClientManageView()
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
