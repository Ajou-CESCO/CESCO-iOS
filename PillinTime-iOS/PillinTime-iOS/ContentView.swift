//
//  ContentView.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 4/9/24.
//

import SwiftUI

struct ContentView: View {
    
    // MARK: - Properties
    
    @State private var selectedTab: TabBarType = .home

    // MARK: - body
    
    var body: some View {
        TabView(selection: $selectedTab) {
            DoseScheduleView()
                .tabItem {
                    Image(selectedTab == .doseSchedule ? "ic_dose_filled" : "ic_dose_unfilled")
                }
                .tag(TabBarType.doseSchedule)
            
            HomeView(userStatus: .manager, selectedClient: 0)
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
}

#Preview {
    ContentView()
}
