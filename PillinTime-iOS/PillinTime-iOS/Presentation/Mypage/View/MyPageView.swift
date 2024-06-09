//
//  MyPageView.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 4/15/24.
//

import SwiftUI

import LinkNavigator
import Moya

struct MyPageView: View {
    
    // MARK: - Properties
    
    @State var showMyPageDetailView: Bool = false
    @State var selectedSettingList: SettingListElement?
    
    let navigator: LinkNavigatorType
    
    init(navigator: LinkNavigatorType) {
        self.navigator = navigator
    }
    
    // MARK: - body
    
    var body: some View {
        
        VStack {
            VStack {
                HStack {
                    Text(UserManager.shared.isManager ?? true ? "보호자" : "피보호자")
                        .font(.body1Medium)
                        .foregroundStyle(Color.primary40)
                        .padding(.leading, 32)
                        .padding(.top, 10)
                        .padding(.bottom, 6)
                    
                    if (UserManager.shared.isSubscriber ?? true) {
                        Image(systemName: "star.fill")
                            .foregroundStyle(Color.primary40)
                    }
                    
                    Spacer()
                }
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
                    
                    ForEach(SettingListElement.topCases, id: \.self) { element in
                        Button(action: {
                            self.showMyPageDetailView = true
                            self.selectedSettingList = element
                        }, label: {
                            VStack {
                                Image(element.image)
                                    .frame(width: 36, height: 36)
                                    .padding(.bottom, 4)
                                
                                Text(element.description)
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
            
            SettingList(navigator: navigator)
        }
        .fullScreenCover(item: $selectedSettingList, content: { element in
            MyPageDetailView(navigator: navigator,
                             settingListElement: element, name: "")
        })
        .transaction { transaction in   // 모달 애니메이션 삭제
            transaction.disablesAnimations = true
        }
    }
}

// MARK: - SettingList

struct SettingList: View {
    
    @State private var isShowingDetailView = false
    @State private var isModalPresented = false

    @State private var selectedElement: SettingListElement?
    @ObservedObject var myPageViewModel: MyPageViewModel
    @ObservedObject var fcmViewModel: FcmViewModel
    
    let navigator: LinkNavigatorType
    
    init(navigator: LinkNavigatorType) {
        self.myPageViewModel = MyPageViewModel()
        self.fcmViewModel = FcmViewModel(fcmService: FcmService(provider: MoyaProvider<FcmAPI>()))
        self.navigator = navigator
    }
        
    var body: some View {
        ZStack {
            Color.gray5
                .edgesIgnoringSafeArea(.all)
            
            ZStack {
                VStack {
                    ForEach(SettingListElement.listCases, id: \.self) { element in
                        Button(action: {
                            selectedElement = element
                            isModalPresented = true
                        }, label: {
                            HStack {
                                Text(element.description)
                                    .font(.h5Medium)
                                    .foregroundColor(Color.gray90)
                                    .frame(height: 50)
                                    .padding(.leading, 25)

                                Spacer()
                            }
                            .background(Color.white)
                            .padding(.vertical, 7)
                            
                        })
                        .buttonStyle(PlainButtonStyle())
                        
                        if element != .withdrawal {
                            Rectangle()
                                .frame(width: 300, height: 1)
                                .foregroundStyle(Color.gray20)
                        }
                    }
                }
                .padding(10)
                .fadeIn(delay: 0.4)
            }
            .background(Color.white)
            .cornerRadius(20)
            .padding(20)
            .fullScreenCover(item: $selectedElement) { element in
                MyPageDetailView(navigator: navigator, settingListElement: element, name: nil)
            }
        }
    }
}
