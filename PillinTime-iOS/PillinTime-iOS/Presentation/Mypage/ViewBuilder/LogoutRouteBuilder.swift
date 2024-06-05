//
//  LogoutRouteBuilder.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 6/4/24.
//

import Foundation

import LinkNavigator

struct LogoutRouteBuilder: RouteBuilder {
    var matchPath: String { "logout" }
    
    var build: (LinkNavigatorType, [String: String], DependencyType) -> MatchingViewController? {
        { navigator, items, dependency in
            return WrappingController(matchPath: matchPath) {
                LogoutView(navigator: navigator).navigationBarHidden(true)
            }
        }
    }
}
