//
//  DoseScheduleStatusView.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 5/2/24.
//

import SwiftUI

import Factory
import Moya

// MARK: - DoseScheduleStatusView

struct DoseScheduleStatusView: View {
    
    /// 찾고자하는 사용자의 clientId
    var memberId: Int
    
    /// 약통이 있는지
    var isCabinetExist: Bool
    
    /// HomeViewModel의 dose log
    @ObservedObject var homeViewModel = Container.shared.homeViewModel.resolve()

    let itemHeight: CGFloat = 45
    let takenStatus: Int?
    @Binding var showAddPillCaseView: Bool
    
    let colors: [Color] = [.error60, .warning60, .success60, .primary40, .purple60]
    let colorToIndex: [Color: Int] = [.error60: 1, .warning60: 2, .success60: 3, .primary40: 4, .purple60: 5]
    
    var body: some View {
        /// 약통이 존재할 경우, 오늘의 약 복용 일정이 보임
        if isCabinetExist {
            if !homeViewModel.doseLog.isEmpty {
                ZStack(alignment: .bottom) {
                    Color.white
                    
                    let filteredLogs = homeViewModel.doseLog.filter { log in
                        if let filterStatus = takenStatus {
                            return log.takenStatus == filterStatus
                        } else {
                            return true
                        }
                    }
                    
                    // 로그가 비어 있는 경우 처리
                    if filteredLogs.isEmpty {
                        VStack {
                            Text("조회 결과가 없습니다.")
                                .font(.body1Medium)
                                .foregroundColor(Color.gray90)
                                .padding()
                        }
                    } else {
                        ScrollView {
                            ForEach(filteredLogs, id: \.id) { log in
                                let color = colors[log.cabinetIndex]
                                
                                HStack {
                                    Circle()
                                        .fill(color)
                                        .frame(width: 20, height: 20)
                                    
                                    Text(log.medicineName)
                                        .font(.h5Bold)
                                        .foregroundStyle(Color.gray90)
                                        .lineLimit(1)
                                        .truncationMode(.tail)
                                        .padding(.leading, 3)
                                    
                                    Spacer()
                                    
                                    Text(formatTime(log.plannedAt))
                                        .font(.body1Bold)
                                        .foregroundStyle(Color.gray70)
                                        .padding(.trailing, 10)

                                    Text(textForTakenStatus(log.takenStatus))
                                        .font(.logo4ExtraBold)
                                        .foregroundColor(colorForDoseStatus(log.takenStatus))
                                        .frame(width: 50)
                                }
                                .padding(5)

                            }
                            .padding(15)

                        }
                    }

                }
                .cornerRadius(8)
                .frame(maxWidth: .infinity,
                       minHeight: 50,
                       maxHeight: min(itemHeight * CGFloat(max(homeViewModel.countLogs(filteringBy: takenStatus), 0)) + 15, 240))
            } else {
                ZStack {
                    Color.gray10
                    
                    VStack {
                        Text("오늘 등록된 복약 일정이 없어요")
                            .font(.body1Bold)
                            .foregroundColor(Color.gray90)
                            .padding(.bottom, 3)
                        
                        Text("복약 일정을 등록하고 알림을 받아보세요")
                            .font(.caption1Medium)
                            .foregroundColor(Color.gray60)
                    }
                    
                }
                .cornerRadius(8)
                .frame(maxWidth: .infinity,
                       minHeight: 150,
                       maxHeight: 150)
                .padding(.bottom, 10)
            }
        } else {
            /// 약통이 존재하지 않을 경우, 약통 등록 유도
            ZStack {
                Color.gray10
                
                VStack {
                    Spacer()
                    
                    Text("등록된 기기가 없어요")
                        .font(.body1Bold)
                        .foregroundColor(Color.gray90)
                        .padding(.bottom, 3)
                    
                    Text("약통을 연동하여 복약 일정을 등록해보세요")
                        .font(.caption1Medium)
                        .foregroundColor(Color.gray60)
                        .padding(.bottom, 20)
                    
                    Button(action: {
                        self.showAddPillCaseView = true
                        print(self.showAddPillCaseView)
                    }, label: {
                        Text("기기 등록하기")
                            .font(.body1Medium)
                            .foregroundStyle(Color.primary90)
                    })
                    .frame(width: 127, height: 48)
                    .background(Color.white)
                    .cornerRadius(8)
                    .padding()
                }
                
            }
            .cornerRadius(8)
            .frame(maxWidth: .infinity,
                   minHeight: 220,
                   maxHeight: 220)
            
        }
    }
    
    /// 복용 여부에 따른 색 설정
    func colorForDoseStatus(_ status: Int) -> Color {
        /// 0 예정 1 완료 2 미완료
        switch status {
        case 1:
            return Color.primary60
        case 2:
            return Color.error60
        case 0:
            return Color.gray30
        default:
            return Color.primary60
        }
    }
    
    /// 시간 포맷팅
    func formatTime(_ time: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "ko_KR")

        if let date = dateFormatter.date(from: time) {
            dateFormatter.dateFormat = "HH시 mm분"
            return dateFormatter.string(from: date)
        } else {
            return "nil"
        }
    }
    
    func textForTakenStatus(_ status: Int) -> String {
        /// 0 예정 1 완료 2 미완료
        switch status {
        case 1:
            return "완료"
        case 2:
            return "미완료"
        case 0:
            return "예정"
        default:
            return "nil"
        }
    }
}
