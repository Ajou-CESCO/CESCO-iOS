//
//  MyPageView.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 4/15/24.
//

import SwiftUI

struct MyPageView: View {
    
    // MARK: - Properties
    
    let mainImage: [String] = ["ic_people", "ic_people", "ic_schedule"]
    let subText: [String] = ["피보호자 관리", "연결된 기기", "복약 일정 관리"]
    
    @State var showMyPageDetailView: Bool = false
    
    // MARK: - body
    
    var body: some View {
        
        VStack {
            VStack {
                Text(UserManager.shared.userType == 0 ? "보호자" : "피보호자")
                    .font(.body1Medium)
                    .foregroundStyle(Color.primary40)
                    .padding(.leading, 32)
                    .padding(.top, 10)
                    .padding(.bottom, 6)
                    .frame(maxWidth: .infinity,
                           alignment: .leading)
                    .fadeIn(delay: 0.1)
                
                Text("\(UserManager.shared.name ?? "null") 님, 안녕하세요!")
                    .font(.logo2Medium)
                    .foregroundStyle(Color.gray90)
                    .padding(.leading, 32)
                    .padding(.bottom, 36)
                    .frame(maxWidth: .infinity,
                           alignment: .leading)
                    .fadeIn(delay: 0.2)
                
                HStack {
                    Spacer()
                    
                    ForEach(0..<3, id: \.self) { index in
                        Button(action: {
                            self.showMyPageDetailView = true
                        }, label: {
                            VStack {
                                Image(mainImage[index])
                                    .frame(width: 36, height: 36)
                                    .padding(.bottom, 4)
                                
                                Text(subText[index])
                                    .font(.body2Regular)
                                    .foregroundStyle(Color.gray90)
                            }
                        })
                        
                        Spacer()
                    }
                    
                }
                .frame(maxWidth: .infinity)
                .fadeIn(delay: 0.3)
            }
            .frame(maxWidth: .infinity,
                   minHeight: 264,
                   maxHeight: 264)
            .background(Color.white)
            
            SettingList()
        }
        .fullScreenCover(isPresented: $showMyPageDetailView,
                         content: {
            MyPageDetailView(settingListElement: .clientManage)
        })
        .transaction { transaction in   // 모달 애니메이션 삭제
            transaction.disablesAnimations = true
        }
    }
}

// MARK: - SettingList

struct SettingList: View {
    
    @State private var isShowingDetailView = false
    @State private var selectedElement: SettingListElement?
    @ObservedObject var myPageViewModel: MyPageViewModel
    
    init() {
        self.myPageViewModel = MyPageViewModel()
    }
        
    var body: some View {
        ZStack {
            Color.gray5
            
            List {
                ForEach(SettingListElement.listCases, id: \.self) { element in
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
            .fadeIn(delay: 0.4)
            .listStyle(.sidebar)
            .background(Color.clear)
        }
    }
}

#Preview {
    MyPageView()
}
