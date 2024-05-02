//
//  DateHelper.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 5/2/24.
//

import Foundation

struct DateHelper {
    var day: String {
        get {
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier:"ko_KR")
            dateFormatter.dateFormat = "EE"
            return dateFormatter.string(from: Date())
        }
        set {
            // 요일 값을 설정할 필요가 없을 때는 set 블록을 비워둘 수 있습니다.
        }
    }
}
