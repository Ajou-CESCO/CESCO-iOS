//
//  ContentRouteBuilder.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 5/1/24.
//

import SwiftUI

import LinkNavigator

struct ContentRouteBuilder: RouteBuilder {
    var matchPath: String { "content" }
    
    var build: (LinkNavigatorType, [String: String], DependencyType) -> MatchingViewController? {
        { navigator, items, dependency in
            return WrappingController(matchPath: matchPath) {
                ContentView(navigator: navigator).navigationBarHidden(true)
            }
        }
    }
}
