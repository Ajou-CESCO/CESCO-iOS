//
//  DoseScheduleRouteBuilder.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 5/6/24.
//

import SwiftUI

import LinkNavigator

struct DoseScheduleRouteBuilder: RouteBuilder {
    var matchPath: String { "doseSchedule" }
    
    var build: (LinkNavigatorType, [String: String], DependencyType) -> MatchingViewController? {
        { navigator, items, dependency in
            return WrappingController(matchPath: matchPath) {
                DoseScheduleView(navigator: navigator).navigationBarHidden(true)
            }
        }
    }
}
