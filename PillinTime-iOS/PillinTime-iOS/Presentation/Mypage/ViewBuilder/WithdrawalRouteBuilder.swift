//
//  WithdrawalRouteBuilder.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 5/27/24.
//

import SwiftUI

import LinkNavigator

struct WithdrawalRouteBuilder: RouteBuilder {
    var matchPath: String { "withdrawal" }
    
    var build: (LinkNavigatorType, [String: String], DependencyType) -> MatchingViewController? {
        { navigator, items, dependency in
            return WrappingController(matchPath: matchPath) {
                WithdrawalView(navigator: navigator).navigationBarHidden(true)
            }
        }
    }
}

