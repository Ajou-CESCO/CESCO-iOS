//
//  HomeRouteBuilder.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 5/29/24.
//

import SwiftUI

import LinkNavigator

struct HomeRouteBuilder: RouteBuilder {
    var matchPath: String { "home" }
    
    var build: (LinkNavigatorType, [String: String], DependencyType) -> MatchingViewController? {
        { navigator, items, dependency in
            return WrappingController(matchPath: matchPath) {
                HomeView(navigator: navigator).navigationBarHidden(true)
            }
        }
    }
}
