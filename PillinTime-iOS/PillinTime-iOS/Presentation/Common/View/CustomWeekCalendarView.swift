//
//  CustomWeekCalendarView.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 5/2/24.
//

import SwiftUI

import Factory

struct CustomWeekCalendarView: View {
    
    // MARK: - Properties
    
    let week: [String] = ["월", "화", "수", "목", "금", "토", "일"]
    var day: String? = DateHelper().day
    @State var isSelectDisabled: Bool = true
    var isDoseAdd: Bool = false // ^^.. doseAdd일 때만 다른 경우가 있어서. .. 이후에 case 추가 시 리팩
    @Binding var selectedDays: Set<String>
    
    // MARK: - Initializer
    
    init(isSelectDisabled: Bool = true, isDoseAdd: Bool = false, selectedDays: Binding<Set<String>>) {
        self.isSelectDisabled = isSelectDisabled
        self.isDoseAdd = isDoseAdd
        self._selectedDays = selectedDays
        if isDoseAdd {
            self.day = nil  // isDoseAdd가 true일 때는 day 사용 x
        }
    }

    // MARK: - body
    
    var body: some View {
        HStack {
            ForEach(week, id: \.self) { weekday in
                Button(action: {
                    // 선택된 요일이 배열에 있다면 제거, 없다면 추가
                    if selectedDays.contains(weekday) {
                        selectedDays.remove(weekday)
                    } else {
                        selectedDays.insert(weekday)
                    }
                }, label: {
                    ZStack {
                        if isDoseAdd && !selectedDays.contains(weekday) {
                            Color(.gray5)
                        } else if weekday == day || selectedDays.contains(weekday) {
                            Color(.primary60)
                        } else {
                            Color(.clear)
                        }
                                            
                        Text(weekday)
                            .font((selectedDays.contains(weekday) || weekday == day) ? .body1Bold : .body1Regular)
                            .foregroundColor((selectedDays.contains(weekday) || weekday == day) ? .white : .gray70)
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

//#Preview {
//    CustomWeekCalendarView()
//}
