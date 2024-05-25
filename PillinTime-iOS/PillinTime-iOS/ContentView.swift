//
//  ContentView.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 4/9/24.
//

import SwiftUI

import LinkNavigator
import Factory

struct ContentView: View {
    
    // MARK: - Properties
    
    @ObservedObject var homeViewModel = Container.shared.homeViewModel.resolve()
    @ObservedObject var toastManager = Container.shared.toastManager.resolve()
    @State private var selectedTab: TabBarType = .home

    let navigator: LinkNavigatorType
    
    init(navigator: LinkNavigatorType) {
        self.navigator = navigator
    }

    // MARK: - body
    
    var body: some View {
        ZStack(alignment: .bottom) {
            NavigationView {
                TabView(selection: $selectedTab) {
                    DoseScheduleView(navigator: navigator)
                        .tabItem {
                            Image(selectedTab == .doseSchedule ? "ic_dose_filled" : "ic_dose_unfilled")
                        }
                        .tag(TabBarType.doseSchedule)
                    
                    HomeView(selectedClientId: 0)
                        .tabItem {
                            Image(selectedTab == .home ? "ic_home_filled" : "ic_home_unfilled")
                        }
                        .tag(TabBarType.home)
                    
                    MyPageView(navigator: navigator)
                        .tabItem {
                            Image(selectedTab == .myPage ? "ic_user_filled" : "ic_user_unfilled")
                        }
                        .tag(TabBarType.myPage)
                }
            }

            if toastManager.show {
                ToastView(description: toastManager.description, show: $toastManager.show)
                    .padding(.bottom, 60)
                    .zIndex(1)
            }
        }
        .background(.clear)
        /// access token이 없다면 로그인 페이지로 넘어갑니다.
        .onAppear {
            if !UserManager.shared.hasAccessToken {
                navigator.next(paths: ["signup"], items: [:], isAnimated: false)
            } else {
                print(UserManager.shared.accessToken)
                HKAuthorizationHelper.shared.setAuthorization()
                homeViewModel.$requestInitClient.send(true)
            }
        
        }
        .navigationBarHidden(true)
    }
}

//#Preview {
//    ContentView(navigator: Na)
//}
