//
//  CustomWeekCalendarHeaderView.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 6/8/24.
//

import SwiftUI

struct CustomWeekCalendarHeaderView: View {
    @Binding var selectedDate: Date
    @State private var currentWeek = [Date]()

    var body: some View {
        VStack {

            ZStack {
                if let firstDayOfWeek = currentWeek.first {
                    Text("\(getFormattedDate(firstDayOfWeek, format: "yyyy년 MMMM"))")
                        .font(.body2Bold)
                        .foregroundStyle(Color.gray90)
                }
                
                HStack {
                    Spacer()
                    
                    Button(action: resetToToday) {
                        Text("오늘")
                            .padding(5)
                            .font(.body2Medium)
                            .background(Color.primary40)
                            .foregroundColor(.white)
                            .cornerRadius(5)
                    }
                    .padding(.horizontal, 35)
                }
            }
            
            HStack(spacing: 10) {
                Button(action: previousWeek) {
                    Image(systemName: "chevron.backward")
                        .foregroundStyle(Color.gray60)
                }
                
                ForEach(currentWeek, id: \.self) { date in
                    VStack {
                        Text(getFormattedDate(date, format: "E"))
                            .font(.caption2Regular)
                            .foregroundStyle(Color.gray90)
                        
                        Text(getFormattedDate(date))
                            .frame(width: 30, height: 30)
                            .background(isSameDay(date1: date, date2: selectedDate) ? Color.primary60 : Color.clear)
                            .foregroundColor(isSameDay(date1: date, date2: selectedDate) ? Color.white : Color.gray90)
                            .cornerRadius(15)
                            .onTapGesture {
                                selectedDate = date
                            }
                    }
                }
                
                Button(action: nextWeek) {
                    Image(systemName: "chevron.forward")
                        .foregroundStyle(Color.gray60)
                }
            }
            .padding(10)
            .onAppear(perform: loadCurrentWeek)

            Spacer()
        }
    }

    private func loadCurrentWeek() {
        currentWeek = getWeek(for: selectedDate)
    }

    private func previousWeek() {
        guard let firstDay = currentWeek.first else { return }
        let previousWeekDate = Calendar.current.date(byAdding: .day, value: -7, to: firstDay)!
        currentWeek = getWeek(for: previousWeekDate)
    }

    private func nextWeek() {
        guard let lastDay = currentWeek.last else { return }
        let nextWeekDate = Calendar.current.date(byAdding: .day, value: 7, to: lastDay)!
        currentWeek = getWeek(for: nextWeekDate)
    }

    private func resetToToday() {
        selectedDate = Date()
        loadCurrentWeek()
    }

    private func getWeek(for date: Date) -> [Date] {
        var week = [Date]()
        let calendar = Calendar.current
        let startOfWeek = calendar.dateInterval(of: .weekOfYear, for: date)!.start
        for i in 0..<7 {
            if let day = calendar.date(byAdding: .day, value: i, to: startOfWeek) {
                week.append(day)
            }
        }
        return week
    }

    private func getFormattedDate(_ date: Date, format: String = "d") -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = format
        return formatter.string(from: date)
    }

    private func isSameDay(date1: Date, date2: Date) -> Bool {
        Calendar.current.isDate(date1, inSameDayAs: date2)
    }
}
