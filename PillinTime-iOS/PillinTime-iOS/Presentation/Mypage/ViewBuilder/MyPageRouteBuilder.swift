//
//  MyPageRouteBuilder.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 5/19/24.
//

import SwiftUI

import LinkNavigator

struct MyPageRouteBuilder: RouteBuilder {
    var matchPath: String { "mypage" }
    
    var build: (LinkNavigatorType, [String: String], DependencyType) -> MatchingViewController? {
        { navigator, items, dependency in
            return WrappingController(matchPath: matchPath) {
                MyPageView(navigator: navigator).navigationBarHidden(true)
            }
        }
    }
}
