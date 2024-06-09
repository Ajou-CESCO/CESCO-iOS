//
//  SelectDosePeriodView.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 5/18/24.
//

import SwiftUI

// MARK: - SelectDosePeriodView

struct SelectDosePeriodView: View {
    
    // MARK: - Properties
    
    @Binding var startDate: Date
    @Binding var endDate: Date
    @Binding var endDateExist: Bool
    @State private var showDatePicker: Bool = false
    @State private var isEndDatePickerDisabled: Bool = false
    var selectedDays: Set<String> = Set<String>()
    
    let dayToInt: [String: Int] = ["월": 1, "화": 2, "수": 3, "목": 4, "금": 5, "토": 6, "일": 7]
    
    var weekdayList: [Int] {
        return selectedDays.compactMap { dayToInt[$0] }.sorted()
    }
    
    private var startDateRange: ClosedRange<Date> {
        let today = Calendar.current.startOfDay(for: Date())
        return today...Date.distantFuture
    }
    
    private var endDateRange: ClosedRange<Date> {
        let firstDay = Calendar.current.date(byAdding: .day, value: 1, to: startDate)!
        return firstDay...Date.distantFuture
    }
    
    // MARK: - body
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            ScrollView {
                DatePickerField(date: $startDate, title: "복용 시작일", symbolName: "calendar", range: startDateRange)
                    .padding(.vertical, 30)
                    .onChange(of: startDate, {
                        let newEndDate = Calendar.current.date(byAdding: .day, value: 1, to: startDate)!
                        if endDate < newEndDate {
                            endDate = newEndDate
                        }
                    })
                
                DatePickerField(date: $endDate, title: "복용 종료일", symbolName: "calendar", range: endDateExist ? startDateRange : endDateRange, isDatePickerDisabled: isEndDatePickerDisabled)
                    .padding(.bottom, 10)
                
                Toggle("종료일 없음", isOn: $endDateExist.animation())
                    .onChange(of: endDateExist, {
                        if endDateExist {
                            endDate = createInfinityEndDate()
                            isEndDatePickerDisabled = true
                        } else {
                            isEndDatePickerDisabled = false
                            endDate = Calendar.current.date(byAdding: .day, value: 1, to: startDate)!
                        }
                    })
                    .frame(width: 125)
                    .font(.body2Regular)
                    .toggleStyle(SwitchToggleStyle(tint: Color.primary60))
            }
        }
    }
    
    private func createInfinityEndDate() -> Date {
        var components = DateComponents()
        components.year = 2099
        components.month = 12
        components.day = 31
        return Calendar.current.date(from: components) ?? Date()
    }
}

// MARK: - DatePickerField

struct DatePickerField: View {
    @Binding var date: Date
    let title: String
    let symbolName: String
    var range: ClosedRange<Date>
    @State private var showPicker = false
    var isDatePickerDisabled: Bool = false

    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.body1Medium)
                .foregroundColor(Color.gray70)
                .padding(.bottom, 5)
                .padding(.leading, 3)

            Button(action: {
                withAnimation {
                    showPicker.toggle()
                }
            }) {
                HStack {
                    Text(date, formatter: DateHelper.yearMonthDayFormatter)
                        .font(.h5Medium)
                        .foregroundColor(isDatePickerDisabled ? .gray60 : .gray90)
                    
                    Spacer()
                    
                    Image(systemName: symbolName)
                        .imageScale(.large)
                }
                .padding()
                .background(Color.gray5)
                .foregroundStyle(isDatePickerDisabled ? Color.gray60 : Color.gray90)
                .cornerRadius(8)

            }
            .disabled(isDatePickerDisabled)

            if showPicker {
                DatePicker(
                    "",
                    selection: $date,
                    in: range,
                    displayedComponents: .date
                )
                
                .datePickerStyle(.graphical)
                .frame(maxHeight: 400)
                .transition(.opacity)
                .onChange(of: date, {
                    withAnimation {
                        showPicker = false
                    }
                })
                .tint(Color.primary60)
            }
        }
    }
    
}
