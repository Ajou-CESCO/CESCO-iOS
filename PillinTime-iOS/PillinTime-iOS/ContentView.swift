//
//  ContentView.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 4/9/24.
//

import SwiftUI

import LinkNavigator

struct ContentView: View {
    
    // MARK: - Properties
    
    let navigator: LinkNavigatorType
    @State private var selectedTab: TabBarType = .home
    
    init(navigator: LinkNavigatorType) {
        self.navigator = navigator
    }

    // MARK: - body
    
    var body: some View {
        NavigationView {
            TabView(selection: $selectedTab) {
                DoseScheduleView(navigator: navigator)
                    .tabItem {
                        Image(selectedTab == .doseSchedule ? "ic_dose_filled" : "ic_dose_unfilled")
                    }
                    .tag(TabBarType.doseSchedule)
                
                HomeView(selectedClient: 0)
                    .tabItem {
                        Image(selectedTab == .home ? "ic_home_filled" : "ic_home_unfilled")
                    } 
                    .tag(TabBarType.home)
                
                MyPageView()
                    .tabItem {
                        Image(selectedTab == .myPage ? "ic_user_filled" : "ic_user_unfilled")
                    }
                    .tag(TabBarType.myPage)
            }
        }
        /// access token이 없다면 로그인 페이지로 넘어갑니다.
        .onAppear {
            print(UserManager.shared.accessToken)
            
            if !UserManager.shared.hasAccessToken {
                navigator.fullSheet(paths: ["signup"], items: [:], isAnimated: false, prefersLargeTitles: .none)
            }
            
        }
        .navigationBarHidden(true)
    }
}

//#Preview {
//    ContentView(navigator: Na)
//}
