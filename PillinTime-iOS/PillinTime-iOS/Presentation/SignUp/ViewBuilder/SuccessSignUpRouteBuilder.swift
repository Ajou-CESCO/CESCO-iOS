//
//  SuccessSignUpRouteBuilder.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 5/15/24.
//

import SwiftUI

import LinkNavigator

struct SuccessSignUpRouteBuilder: RouteBuilder {
    var matchPath: String { "successSignUp" }
    
    var build: (LinkNavigatorType, [String: String], DependencyType) -> MatchingViewController? {
        { navigator, items, dependency in
            return WrappingController(matchPath: matchPath) {
                SuccessSignUpView(navigator: navigator).navigationBarHidden(true)
            }
        }
    }
}
