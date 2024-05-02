//
//  DoseScheduleStatusView.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 5/2/24.
//

import SwiftUI

// MARK: - DoseScheduleStatusView

struct DoseScheduleStatusView: View {
    
    /// 약통이 등록되어 있는지, 아닌지에 따라 뷰의 구성이 달라짐
    var isPillCaseExist: Bool
    
    let itemHeight: CGFloat = 55
    @ObservedObject var viewModel = ClientListViewModel()
    let doseStatus: DoseStatus?
    
    var body: some View {
        /// 약통이 존재할 경우, 오늘의 약 복용 일정이 보임
        if isPillCaseExist {
            ZStack {
                Color.white
                    
                VStack(alignment: .leading) {
                    ForEach(viewModel.todayDoesLog.filter { log -> Bool in
                        // 여기에서 doseStatus가 nil이 아닐 때만 필터링 조건을 적용합니다.
                        if let filterStatus = doseStatus {
                            return log.doseStatus == filterStatus
                        }
                        // doseStatus가 nil이면 모든 데이터를 출력합니다.
                        return true
                    }, id: \.self) { log in
                        HStack {
                            Text(log.pillName)
                                .font(.h5Bold)
                                .foregroundStyle(Color.gray90)
                                .padding(.bottom, 2)
                            
                            Spacer()
                            
                            Text(log.doseTime)
                                .font(.body1Bold)
                                .foregroundStyle(Color.gray70)
                                .padding(.trailing, 10)
                            
                            Text(log.doseStatus.description)
                                .font(.logo4ExtraBold)
                                .foregroundColor(colorForDoseStatus(log.doseStatus))
                                .frame(width: 50)
                        }
                    }
                    .padding(7)
                }
                .padding([.leading, .trailing], 20)
            }
            .cornerRadius(8)
            .frame(maxWidth: .infinity,
                   minHeight: itemHeight * CGFloat(viewModel.countLogs(filteringBy: doseStatus)),
                   maxHeight: itemHeight * CGFloat(viewModel.countLogs(filteringBy: doseStatus)))
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
                        
                    }, label: {
                        Text("기기 등록하기")
                            .font(.body1Medium)
                            .foregroundStyle(Color.primary90)
                    })
                    .cornerRadius(8)
                    .frame(width: 127, height: 48)
                    .background(Color.white)
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
    func colorForDoseStatus(_ status: DoseStatus) -> Color {
        switch status {
        case .taken:
            return Color.primary60
        case .missed:
            return Color.error60
        case .scheduled:
            return Color.gray30
        }
    }
}
