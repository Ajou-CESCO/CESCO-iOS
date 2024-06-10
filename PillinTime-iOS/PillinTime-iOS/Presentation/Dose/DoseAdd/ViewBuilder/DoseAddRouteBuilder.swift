//
//  DoseAddRouteBuilder.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 5/6/24.
//

import SwiftUI

import LinkNavigator

struct DoseAddRouteBuilder: RouteBuilder {
    var matchPath: String { "doseAdd" }
    
    var build: (LinkNavigatorType, [String: String], DependencyType) -> MatchingViewController? {
        { navigator, items, dependency in
            return WrappingController(matchPath: matchPath) {
                DoseAddView(navigator: navigator).navigationBarHidden(true)
            }
        }
    }
}
