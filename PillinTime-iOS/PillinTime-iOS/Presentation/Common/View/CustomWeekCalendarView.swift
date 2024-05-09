//
//  CustomWeekCalendarView.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 5/2/24.
//

import SwiftUI

struct CustomWeekCalendarView: View {
    
    // MARK: - Properties
    
    let week: [String] = ["월", "화", "수", "목", "금", "토", "일"]
    let day: String = DateHelper().day
    var isSelectDisabled: Bool = true

    // MARK: - body
    
    var body: some View {
        HStack {
            ForEach(0..<week.count, id: \.self) { index in
                Button(action: {
                    
                }, label: {
                    ZStack {
                        Color(week[index] == day ? .primary60 : .clear)
                        
                        Text(week[index])
                            .font(week[index] == day ? .body1Bold : .body1Regular)
                            .foregroundStyle(Color(week[index] == day ? .white : .gray70))
                    }
                    .cornerRadius(10)
                    .frame(width: 38, height: 42)
                })
                .disabled(isSelectDisabled)
                .padding(1)
            }
        }
    }
    
    
    func getDayOfWeek(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEEEE"
        formatter.locale = Locale(identifier: "ko_KR")
        let convertStr = formatter.string(from: date)
        return convertStr
    }

}

#Preview {
    CustomWeekCalendarView()
}
