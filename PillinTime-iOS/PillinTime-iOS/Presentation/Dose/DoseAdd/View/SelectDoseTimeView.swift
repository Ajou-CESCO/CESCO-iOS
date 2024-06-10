//
//  SelectDoseTimeView.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 5/18/24.
//

import Foundation
import SwiftUI

// MARK: - TimeIdentifier

struct TimeIdentifier: Hashable {
    let time: String
    let period: String  // 오전, 오후 구분
}

// MARK: - SelectDoseTimeView

struct SelectDoseTimeView: View {
    
    // MARK: - Properties
    
    @State private var isExpanded = false
    @State private var selectedTimes = Set<TimeIdentifier>()
    @Binding var selectedTimeStrings: [String] // 실제 서버에 보낼 값들
    
    let morningTimes = (0...11).flatMap { hour -> [String] in
        ["\(hour):00", "\(hour):30"]
    }
    
    let afternoonTimes = (12...23).flatMap { hour -> [String] in
        ["\(hour):00", "\(hour):30"]
    }
    
    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 3)

    // MARK: - body
    
    var body: some View {
        VStack {
            Button(action: {
                self.isExpanded.toggle()
            }) {
                VStack {
                    HStack {
                        Image(systemName: "alarm.fill")
                            .padding(.trailing, 5)
                        Text("시간 선택")
                            .font(.body1Medium)
                            .foregroundColor(Color.gray70)
                        Spacer()
                        Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        
                    }
                    
                    if isExpanded {
                        ScrollView(showsIndicators: false) {
                            VStack(alignment: .leading) {
                                Text("오전")
                                    .font(.body1Bold)
                                    .foregroundStyle(Color.gray90)
                                    .padding(5)
                                
                                LazyVGrid(columns: columns, spacing: 10) {
                                    ForEach(morningTimes, id: \.self) { time in
                                        TimeButton(time: time, isSelected: selectedTimes.contains(TimeIdentifier(time: time, period: "AM"))) {
                                            toggleTimeSelection(time, "AM")
                                        }
                                    }
                                }
                                .padding(.bottom, 20)
                                
                                Text("오후")
                                    .font(.body1Bold)
                                    .foregroundStyle(Color.gray90)
                                    .padding(5)
                                
                                LazyVGrid(columns: columns, spacing: 10) {
                                    ForEach(afternoonTimes, id: \.self) { time in
                                        TimeButton(time: time, isSelected: selectedTimes.contains(TimeIdentifier(time: time, period: "PM"))) {
                                            toggleTimeSelection(time, "PM")
                                        }
                                    }
                                }
                            }
                            .padding()
                            .background(Color.white)
                        }
                        .fadeIn(delay: 0.1)
                    }
                }
                .padding()
                .background(Color.white)
                .foregroundColor(Color.gray70)
                .cornerRadius(10)
                .shadow(color: .gray50, radius: 3)
            }
        }
    }
    
    /// 시간 선택을 토글하는 함수
    private func toggleTimeSelection(_ time: String, _ period: String) {
        let timeIdentifier = TimeIdentifier(time: time, period: period)
        if selectedTimes.contains(timeIdentifier) {
            selectedTimes.remove(timeIdentifier)
        } else {
            selectedTimes.insert(timeIdentifier)
        }
        updateSelectedTimeStrings()
    }
    
    /// 서버로 전송할 시간으로 변경하는 함수
    private func updateSelectedTimeStrings() {
        selectedTimeStrings = selectedTimes.map { identifier -> String in
            let hour = Int(identifier.time.split(separator: ":")[0])!
            let minute = identifier.time.split(separator: ":")[1]
            return String(format: "%02d:%@", hour, minute as CVarArg)
        }.sorted()
    }
}

// MARK: - TimeButton

struct TimeButton: View {
    let time: String
    var isSelected: Bool
    var action: () -> Void

    var body: some View {
        Button(time, action: action)
            .padding(15)
            .frame(maxWidth: .infinity)
            .foregroundColor(isSelected ? .white : .gray50)
            .font(.body1Medium)
            .background(
                RoundedRectangle(cornerRadius: 10, style: .continuous).fill(isSelected ? Color.primary60 : Color.white)
            )
            .overlay {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(isSelected ? .white : .gray50)
            }
    }
}
