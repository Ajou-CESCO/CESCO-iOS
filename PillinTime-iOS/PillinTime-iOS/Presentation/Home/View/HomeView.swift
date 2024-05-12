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
    
    @ObservedObject var clientListViewModel = ClientListViewModel()
    @State var selectedClient: Int?  // 선택된 Client
    @State private var showEncourageView: Bool = false
    
    // MARK: - body
    
    var body: some View {
        VStack(alignment: .leading) {
            /// 보호자일 경우
            if (UserManager.shared.userType == 0) {
                ClientListView(viewModel: clientListViewModel,
                               selectedClient: $selectedClient)
                    .padding(.bottom, 17)
                    .fadeIn(delay: 0.1)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 0) {
                        ForEach(0..<clientListViewModel.clients.count, id: \.self) { index in
                            
                            VStack(alignment: .leading) {
                                Text.multiColoredText("오늘 \(clientListViewModel.clients[index].userName) 님의 약속시간은?",
                                                      coloredSubstrings: [(clientListViewModel.clients[index].userName, Color.primary60),
                                                                        ("약", Color.primary60)])
                                    .foregroundStyle(Color.gray90)
                                    .font(.logo3Medium)
                                    .padding(.leading, 33)
                                    .fadeIn(delay: 0.2)
                                
                                DoseScheduleStatusView(isPillCaseExist: false,
                                                       doseStatus: nil)
                                    .padding([.top, .bottom], 10)
                                    .padding([.leading, .trailing], 25)
                                    .fadeIn(delay: 0.3)
                                
                                if showEncourageView {
                                    EncourageMainView()
                                        .transition(.move(edge: .top))
                                        .scaleFadeIn(delay: 0.4)
                                        .padding([.leading, .trailing], 25)
                                }
                                
                                HealthMainView()
                                    .padding(.top, showEncourageView ? 14 : 0) // EncourageMainView 표시에 따라 조정
                                    .fadeIn(delay: 0.5)
                                    .padding([.leading, .trailing], 25)
                                
                                Spacer()
                            }
                            .containerRelativeFrame(.horizontal)
                        }
                    }
                    .scrollTargetLayout(isEnabled: true)
                }
                .scrollTargetBehavior(.viewAligned)
                .scrollPosition(id: $selectedClient)
            } else {
                HStack {
                    Text.multiColoredText("\(UserManager.shared.name ?? "null") 님,\n오늘 하루도 화이팅이에요!", coloredSubstrings: [(UserManager.shared.name ?? "null", Color.primary60)])
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
                
                DoseScheduleStatusView(isPillCaseExist: false, doseStatus: nil)
                    .padding([.top, .bottom], 18)
                    .padding([.leading, .trailing], 25)
                    .fadeIn(delay: 0.3)
                
                if showEncourageView {
                    EncourageMainView()
                        .transition(.move(edge: .top))
                        .scaleFadeIn(delay: 0.4)
                        .padding([.leading, .trailing], 25)
                }
                
                HealthMainView()
                    .padding(.top, showEncourageView ? 17 : 0) // EncourageMainView 표시에 따라 조정
                    .fadeIn(delay: 0.5)
                    .padding([.leading, .trailing], 25)
                
                Spacer()
            }
        }
        .background(Color.gray5)
        .onAppear {
            // 여기서 조금 지연된 후에 EncourageMainView를 표시
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                withAnimation {
                    self.showEncourageView = true
                }
            }
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

// MARK: - EncourageMainView

struct EncourageMainView: View {
    
    // MARK: - Properties
    
    var mainTitle: String = "오늘 많이 걸으셨나요?"
    var subTitle: String = "50대 평균보다 300보 덜 걸으셨어요."
    
    // MARK: - body
    
    var body: some View {
        HStack {
            LottieView(lottieFile: "pie-chart")
                .frame(width: 70, height: 70)
            
            VStack(alignment: .leading) {
                Text(mainTitle)
                    .font(.logo4Medium)
                    .foregroundStyle(Color.gray90)
                    .padding(.bottom, 1)
                
                Text(subTitle)
                    .font(.body2Medium)
                    .foregroundStyle(Color.gray50)
            }
        }
        .frame(maxWidth: .infinity, minHeight: 90, maxHeight: 90)
        .background(Color.white)
        .cornerRadius(8)
    }
}
