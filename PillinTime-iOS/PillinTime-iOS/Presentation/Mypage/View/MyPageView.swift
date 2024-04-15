//
//  MyPageView.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 4/15/24.
//

import SwiftUI

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

struct MyPageView: View {
    
    let mainText: [String] = ["예정된 횟수", "완료한 횟수", "미완료 횟수"]
    let subText: [String] = ["12회", "23회", "70회"]
    
    var body: some View {
        
        NavigationView {
            VStack {
                VStack {
                    Text("보호자")
                        .font(.body1Medium)
                        .foregroundStyle(Color.primary40)
                        .padding(.leading, 32)
                        .padding(.top, 10)
                        .padding(.bottom, 6)
                        .frame(maxWidth: .infinity,
                               alignment: .leading)
                    
                    Text("세스코 님, 안녕하세요!")
                        .font(.logo2Medium)
                        .foregroundStyle(Color.gray90)
                        .padding(.leading, 32)
                        .padding(.bottom, 36)
                        .frame(maxWidth: .infinity,
                               alignment: .leading)
                    
                    HStack {
                        Spacer()
                        
                        ForEach(0..<3, id: \.self) { index in
                            VStack {
                                Text(mainText[index])
                                    .font(.body2Regular)
                                    .foregroundStyle(Color.gray90)
                                    .padding(.bottom, 5)
                                
                                Text(subText[index])
                                    .font(.h5Bold)
                                    .foregroundStyle(Color.gray70)
                            }
                            
                            Spacer()
                        }
                        
                    }
                    .frame(maxWidth: .infinity)
                }
                .frame(maxWidth: .infinity,
                       minHeight: 264,
                       maxHeight: 264)
                .background(Color.white)
                
                SettingList()
            }
        }
        .navigationBarHidden(true)
    }
}

// MARK: - SettingList

struct SettingList: View {
    
    @State private var isShowingDetailView = false
    @State private var selectedElement: SettingListElement?
        
    var body: some View {
        ZStack {
            Color.gray5
            
            List {
                ForEach(SettingListElement.allCases, id: \.self) { element in
                    ZStack {
                        NavigationLink(destination: MyPageDetailView(settingListElement: element)) {
                            EmptyView()
                        }
                        .opacity(0.0)
                        .buttonStyle(PlainButtonStyle())
                        .background(Color.clear)
                        .listRowSeparator(.hidden)
                        
                        HStack {
                            Text(element.description)
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(Color.black)
                                .frame(height: 50)
                                .padding(.leading, 5)
                            
                            Spacer()
                        }
                        
                    }
                    
                }
            }
            .listStyle(.sidebar)
            .background(Color.clear)
        }
    }
}

#Preview {
    MyPageView()
}
