//
//  PillinTime_iOSApp.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 4/9/24.
//

import SwiftUI
import LinkNavigator
import Moya

@main
struct PillinTime_iOSApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate

    var navigator: LinkNavigator {
        appDelegate.navigator
    }
    
    var body: some Scene {
        WindowGroup {
            navigator
                .launch(paths: ["content"], items: [:])
                .ignoresSafeArea(edges: .vertical)
//                .onOpenURL { url in
//                    // 딥링크 네비게이션이 필요한 경우, URL 편집 수행
//                }
        }
    }
}
