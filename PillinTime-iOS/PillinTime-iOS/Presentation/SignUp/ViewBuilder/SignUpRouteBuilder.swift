//
//  SignUpRouteBuilder.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 5/1/24.
//

import SwiftUI

import LinkNavigator

struct SignUpRouteBuilder: RouteBuilder {
    var matchPath: String { "signup" }
    
    var build: (LinkNavigatorType, [String: String], DependencyType) -> MatchingViewController? {
        { navigator, items, dependency in
            return WrappingController(matchPath: matchPath) {
                SignUpView(navigator: navigator).navigationBarHidden(true)
            }
        }
    }
}
