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
    
    /// time 배열을 string 하나로 묶어서 배열
    static func convertTimeStrings(_ timeStrings: [String]) -> String {
        let inputDateFormatter = DateFormatter()
        inputDateFormatter.dateFormat = "HH:mm:ss"
        
        let outputDateFormatter = DateFormatter()
        outputDateFormatter.dateFormat = "a h시 mm분"
        outputDateFormatter.locale = Locale(identifier: "ko_KR")
        
        let times = timeStrings.compactMap { timeString -> String? in
            if let date = inputDateFormatter.date(from: timeString) {
                return outputDateFormatter.string(from: date)
            }
            return nil
        }
        
        return times.joined(separator: ", ")
    }
    
    /// 그날 오후 6시
    func getTodaySixPM(_ date: Date) -> Date {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        components.hour = 18
        components.minute = 0
        components.second = 0
        let todaySixPM = calendar.date(from: components)!

        return todaySixPM
    }
    
    /// 기준 날짜에 특정 일 수를 뺀 날짜를 반환합니다.
    static func subtractDays(from date: Date, days: Int) -> Date {
        
        assert(days >= 0, "일 수는 0보다 커야합니다.")
        
        let calendar = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.day = -days
        
        return calendar.date(byAdding: dateComponents, to: date)!
    }
    
    /// 전날 오후 6시
    func getYesterdaySixPM(_ date: Date) -> Date {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        let yesterday = calendar.date(byAdding: .day, value: -1, to: date)!
        components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: yesterday)
        components.hour = 18
        components.minute = 0
        components.second = 0
        let yesterdaySixPM = calendar.date(from: components)!

        return yesterdaySixPM
    }
    
    /// 어제 시작 시각 (00:00) 구하기
    func getYesterdayStartAM(_ date: Date) -> Date {
        let calendar = Calendar.current
        
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        let yesterday = calendar.date(byAdding: .day, value: -2, to: date)!
        components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: yesterday)
        components.hour = 24 // 한국 기준 24:00:00이 시작이므로
        components.minute = 0
        components.second = 0
        let yesterdayStartAM = calendar.date(from: components)!
        
        return yesterdayStartAM
    }
    
    /// 어제 끝 시각 (23:59) 구하기
    func getYesterdayEndPM(_ date: Date) -> Date {
        let calendar = Calendar.current
        
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        let yesterday = calendar.date(byAdding: .day, value: -1, to: date)!
        components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: yesterday)
        components.hour = 23 // 한국 기준 23:59:59가 마지막이므로
        components.minute = 59
        components.second = 59
        let yesterdayEndPM = calendar.date(from: components)!
        return yesterdayEndPM
    }
}
