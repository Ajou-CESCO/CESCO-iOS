//
//  MyPageDetailRouteBuilder.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 5/19/24.
//

import SwiftUI

import LinkNavigator

struct MyPageDetailRouteBuilder: RouteBuilder {
    var matchPath: String { "mypageDetail" }
    
    var build: (LinkNavigatorType, [String: String], DependencyType) -> MatchingViewController? {
        { navigator, items, dependency in
            return WrappingController(matchPath: matchPath) {
                MyPageDetailView(navigator: navigator, settingListElement: .logout).navigationBarHidden(true)
            }
        }
    }
}
