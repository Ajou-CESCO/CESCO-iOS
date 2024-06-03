//
//  MyPageDetailView.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 4/15/24.
//

import SwiftUI

import LinkNavigator
import Factory

// 이후 다른 곳으로 이동할 것
@frozen
enum UserProfile {
    case name
    case phoneNumber
    case ssn
    case isPillCaseExist
    
    var description: String {
        switch self {
        case .name:
            return "성명"
        case .phoneNumber:
            return "휴대폰 번호"
        case .ssn:
            return "주민등록번호"
        case .isPillCaseExist:
            return ""
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
    @ObservedObject var homeViewModel = Container.shared.homeViewModel.resolve()
    
    @State var name: String?
    let navigator: LinkNavigatorType
    
    init(navigator: LinkNavigatorType, settingListElement: SettingListElement, name: String?) {
        self.navigator = navigator
        self.settingListElement = settingListElement
        self.name = name
    }
    
    // MARK: - body
    
    var body: some View {
        ZStack {
            Color.gray5
                .ignoresSafeArea()
            
            VStack {
                CustomNavigationBar(title: settingListElement.description)
                
                switch settingListElement {
                case .managementMyInformation:
                    ManagementMyInformationView(userInfo: SelectedRelation(relationId: UserManager.shared.memberId ?? 0,
                                                                           name: UserManager.shared.name ?? "null",
                                                                           ssn: UserManager.shared.ssn ?? "null",
                                                                           phone: UserManager.shared.phoneNumber ?? "null",
                                                                           cabinetId: homeViewModel.clientCabnetId))
                case .subscriptionPaymentHistory:
                    SubscriptionPaymentHistoryView()
                case .customerServiceCenter:
                    CustomerServiceCenterView()
                case .withdrawal:
                    WithdrawalView(navigator: navigator)
                case .clientManage:
                    ClientManageView()
                case .managementDoseSchedule:
                    ManagementDoseScheduleView()
                case .todaysHealthState:
                    HealthDashBoardView(name: (UserManager.shared.isManager ?? true) ? (UserManager.shared.selectedClientName ?? "null"): (UserManager.shared.name ?? "null"))
                case .bugReport:
                    BugReportView()
                case .logout:
                    LogoutView(navigator: navigator)
                }
                
                Spacer()
            }
            .navigationBarHidden(true)
        }
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
