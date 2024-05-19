//
//  DateHelper.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 5/2/24.
//

import Foundation

struct DateHelper {
    static let koreanLocaleFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter
    }()
    
    /// 오늘의 요일을 문자열로 반환
    static var todayDay: String {
        koreanLocaleFormatter.dateFormat = "EEEEE"
        return koreanLocaleFormatter.string(from: Date())
    }
    
    /// 날짜를 문자열로 변경
    static func dateString(_ date: Date) -> String {
        koreanLocaleFormatter.dateFormat = "yyyy-MM-dd"
        return koreanLocaleFormatter.string(from: date)
    }
    
    /// 년,월,일 formatter
    static var yearMonthDayFormatter: DateFormatter {
        koreanLocaleFormatter.dateFormat = "yyyy년 MM월 dd일"
        return koreanLocaleFormatter
    }
}
