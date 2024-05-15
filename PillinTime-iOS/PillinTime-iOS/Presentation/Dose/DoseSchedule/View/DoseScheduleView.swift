//
//  DoseScheduleView.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 4/14/24.
//

import SwiftUI

import LinkNavigator

struct DoseScheduleView: View {
    
    // MARK: - Properties
    
    @State private var selectedDays = Set<String>()
    @ObservedObject var clientListViewModel = ClientListViewModel()
    @State var selectedClient: Int?  // 선택된 Client
    @State var isUserPoked: Bool = false
    let navigator: LinkNavigatorType
    
    init(navigator: LinkNavigatorType) {
        self.navigator = navigator
    }

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            VStack {
                if (UserManager.shared.userType == 0) {
                    ClientListView(viewModel: clientListViewModel,
                                   selectedClient: $selectedClient)
                        .fadeIn(delay: 0.1)
                }
                
                CustomWeekCalendarView(selectedDays: $selectedDays)
                    .padding(.top, 17)
                    .fadeIn(delay: 0.2)
                    .frame(maxWidth: .infinity, minHeight: 80, maxHeight: 80)
                    .background(UserManager.shared.userType == 0 ? .clear : .white)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 0) {
                        ForEach(0..<clientListViewModel.clients.count, id: \.self) { index in
                            ScrollView(.vertical, showsIndicators: false) {
                                VStack {
                                    ZStack(alignment: .topTrailing) {
                                        DoseScheduleSubView(doseStatus: .scheduled)
                                            .padding(.top, UserManager.shared.userType == 0 ? 5 : 20)
                                            .padding(.bottom, 20)
                                            .fadeIn(delay: 0.3)
                                        // 이후에 수정할 것
                                        if (true) {
                                            Button(action: {
                                                self.isUserPoked = true
                                                print(self.isUserPoked)
                                            }, label: {
                                                HStack {
                                                    if isUserPoked {
                                                        Text("찌르기 완료")
                                                            .font(.body2Medium)
                                                            .foregroundStyle(Color.gray70)
                                                            .padding(6)
                                                    } else {
                                                        Image("ic_poke")
                                                            .frame(width: 30, height: 30)
                                                        Text("찌르기")
                                                            .font(.body2Medium)
                                                            .foregroundColor(Color.gray70)
                                                            .padding(.trailing, 2)
                                                    }
                                                }
                                                .padding(5)
                                                .background(Color.white)
                                                .cornerRadius(8)
                                                .overlay(RoundedRectangle(cornerRadius: 8)
                                                    .stroke(Color.gray10, lineWidth: 2)
                                                )

                                            })
                                            .disabled(isUserPoked)
                                            .padding(.trailing, 25)
                                            .fadeIn(delay: 0.3)
                                        }
                                    }
                                    
                                    DoseScheduleSubView(doseStatus: .missed)
                                        .padding(.bottom, 20)
                                        .fadeIn(delay: 0.4)
                                    
                                    DoseScheduleSubView(doseStatus: .taken)
                                        .padding(.bottom, 20)
                                        .fadeIn(delay: 0.5)
                                    
                                    Spacer()
                                }
                                .containerRelativeFrame(.horizontal)
                            }
                            
                        }
                    }
                    .scrollTargetLayout(isEnabled: true)
                }
                .scrollTargetBehavior(.viewAligned)
                .scrollPosition(id: $selectedClient)
                
                if isUserPoked {
                    ToastView(description: "\(clientListViewModel.clients[selectedClient ?? 0].userName) 님을 콕 찔렀어요.",
                              show: $isUserPoked)
                        .padding(.bottom, 20)
                }
            }
            .background(Color.gray5)
            
            Button(action: {
                self.navigator.next(paths: ["doseAdd"], items: [:], isAnimated: true)
            }, label: {
                HStack {
                    Image(systemName: "plus")
                        .frame(width: 10, height: 10)
                        .foregroundColor(Color.white)
                        .padding(.leading, 20)
                    
                    Text("약 추가")
                        .font(.body1Bold)
                        .foregroundStyle(Color.white)
                        .padding(.trailing, 20)
                }
            })
            .padding([.top, .bottom], 15)
            .background(Color.primary60)
            .cornerRadius(30)
            .padding(.trailing, 20)
            .padding(.bottom, 25)
            .fadeIn(delay: 0.6)
        }
    }
}

// MARK: - DoseScheduleSubView

struct DoseScheduleSubView: View {
    
    // MARK: - body
    
    let doseStatus: DoseStatus
    
    var body: some View {
        VStack(alignment: .center) {
            HStack {
                switch doseStatus {
                case .taken:
                    Image("ic_dose_blue")
                        .frame(width: 20, height: 20)
                        .padding(.leading, 25)
                        .padding(.trailing, 1)
                    
                    Text("완료한 약속시간")
                        .font(.body2Medium)
                        .foregroundStyle(Color.gray70)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                case .missed:
                    Image("ic_dose_red")
                        .frame(width: 20, height: 20)
                        .padding(.leading, 25)
                        .padding(.trailing, 1)

                    Text("미완료한 약속시간")
                        .font(.body2Medium)
                        .foregroundStyle(Color.gray70)
                        .frame(maxWidth: .infinity, alignment: .leading)

                case .scheduled:
                    Image("ic_dose_gray")                        
                        .frame(width: 20, height: 20)
                        .padding(.leading, 25)
                        .padding(.trailing, 1)
                    
                    Text("예정된 약속시간")
                        .font(.body2Medium)
                        .foregroundStyle(Color.gray70)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            
            DoseScheduleStatusView(isPillCaseExist: true, doseStatus: doseStatus)
                .padding([.top, .bottom], 15)
                .padding([.leading, .trailing], 25)
        }
    }
}

//#Preview {
//    DoseScheduleView(navigator: <#any LinkNavigatorType#>)
//}
