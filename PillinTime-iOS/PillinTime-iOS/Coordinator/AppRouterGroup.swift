//
//  AppRouterGroup.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 5/1/24.
//

import LinkNavigator

/// 이동하고 싶은 화면들을 관리하는 타입입니다.
struct AppRouterGroup {
    var routers: [RouteBuilder] {
        [
            ContentRouteBuilder(),
            SignUpRouteBuilder(),
            DoseScheduleRouteBuilder(),
            DoseAddRouteBuilder()
        ]
    }
}
