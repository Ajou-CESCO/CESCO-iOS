//
//  HomeView.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 4/14/24.
//

import SwiftUI

@frozen
enum UserStatus {   // 이후 옮길 것 (사용자의 유형 분류)
    case manager
    case client
}

@frozen
enum DoseStatus {
    case taken
    case missed
    case scheduled
    
    var description: String {
        switch self {
        case .taken:
            return "완료"
        case .missed:
            return "미완료"
        case .scheduled:
            return "예정"
        }
    }
}

struct HomeView: View {
    
    // MARK: - Properties
    
    @ObservedObject var viewModel = ClientListViewModel()
    @State var userStatus: UserStatus      // 사용자 상태값
    @State var selectedClient: Int  // 선택된 Client
    
    // MARK: - body
    
    var body: some View {
        VStack(alignment: .leading) {
            if userStatus == .manager {
                ClientListView(viewModel: viewModel,
                               selectedClient: selectedClient)
                    .padding(.bottom, 17)
                
                Text.multiColoredText("오늘 이재현 님의 약속시간은?", coloredSubstrings: [("이재현", Color.primary60),
                                                                                    ("약", Color.primary60)])
                    .foregroundStyle(Color.gray90)
                    .font(.logo3Medium)
                    .padding(.leading, 33)
            } else {
                HStack {
                    Text.multiColoredText("이재현 님,\n오늘 하루도 화이팅이에요!", coloredSubstrings: [("이재현", Color.primary60)])
                        .foregroundStyle(Color.gray90)
                        .font(.logo3Medium)
                        .lineSpacing(3)
                        .frame(alignment: .leading)
                    
                    Spacer()
                    
                    Button(action: {
                        
                    }, label: {
                        Image("ic_alarm_filled")    // 이후에 분기
                            .frame(width: 36, height: 36)
                    })
                }
                .padding([.leading, .trailing], 33)
                .padding(.top, 23)
            }
            
            DoesHomeView(isPillCaseExist: true)
                .padding(.top, 18)
                .padding([.leading, .trailing], 25)
            
            HealthMainView()
                .padding(.top, 12)
                .padding([.leading, .trailing], 25)
            
            Spacer()
            
        }
        .background(Color.gray5)
    }
}

// MARK: - DoesHomeView

struct DoesHomeView: View {
    
    /// 약통이 등록되어 있는지, 아닌지에 따라 뷰의 구성이 달라짐
    var isPillCaseExist: Bool
    
    let itemHeight: CGFloat = 55
    @ObservedObject var viewModel = ClientListViewModel()
    
    var body: some View {
        /// 약통이 존재할 경우, 오늘의 약 복용 일정이 보임
        if isPillCaseExist {
            ZStack {
                Color.white
                    
                VStack(alignment: .leading) {
                    ForEach(viewModel.todayDoesLog.indices, id: \.self) { index in
                        HStack {
                            Text(viewModel.todayDoesLog[index].pillName)
                                .font(.h5Bold)
                                .foregroundStyle(Color.gray90)
                            .padding(.bottom, 2)
                            
                            Spacer()
                            
                            Text(viewModel.todayDoesLog[index].doseTime)
                                .font(.body1Bold)
                                .foregroundStyle(Color.gray70)
                                .padding(.trailing, 10)
                            
                            Text(viewModel.todayDoesLog[index].doseStatus.description)
                                .font(.logo4ExtraBold)
                                .foregroundColor(colorForDoseStatus(viewModel.todayDoesLog[index].doseStatus))
                                .frame(width: 50)
                        }
                    }
                    .padding(7)
                }
                .padding([.leading, .trailing], 20)
            }
            .cornerRadius(8)
            .frame(maxWidth: .infinity,
                   minHeight: itemHeight * CGFloat(viewModel.todayDoesLog.count),
                   maxHeight: itemHeight * CGFloat(viewModel.todayDoesLog.count))
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

// MARK: - HealthMainView

struct HealthMainView: View {
    
    // MARK: - Properties
    
    var mainText: [String] = ["걸음 수", "하품 횟수", "소화 횟수"]
    var subText: [String] = ["99,110보", "45,300회", "23,244회"]
    
    // MARK: - body
    
    var body: some View {
        ZStack {
            Color.primary60
            
            HStack(spacing: 36) {
                ForEach(0..<3, id: \.self) { index in
                    VStack {
                        Text(mainText[index])
                            .font(.caption1Medium)
                            .foregroundStyle(Color.primary40)
                            .padding(.bottom, 2)
                        
                        Text(subText[index])
                            .font(.body1Bold)
                            .foregroundStyle(Color.white)
                    }
                }
            }
        }
        .cornerRadius(8)
        .frame(maxWidth: .infinity, minHeight: 80, maxHeight: 80)
    }
}

#Preview {
    HomeView(userStatus: .manager, selectedClient: 0)
}
