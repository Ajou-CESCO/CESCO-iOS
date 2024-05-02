//
//  DoseScheduleView.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 4/14/24.
//

import SwiftUI

struct DoseScheduleView: View {
    
    // MARK: - Properties
    
    @ObservedObject var clientListViewModel = ClientListViewModel()
    @State var selectedClient: Int?  // 선택된 Client

    var body: some View {
        VStack {
            if (UserManager.shared.userType == 0) {
                ClientListView(viewModel: clientListViewModel,
                               selectedClient: $selectedClient)
                    .fadeIn(delay: 0.1)
            }
            
            CustomWeekCalendarView()
                .padding(.top, 17)
                .fadeIn(delay: 0.2)
                .frame(maxWidth: .infinity, minHeight: 80, maxHeight: 80)
                .background(UserManager.shared.userType == 0 ? .clear : .white)
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 0) {
                    ForEach(0..<clientListViewModel.clients.count, id: \.self) { index in
                        ScrollView(.vertical, showsIndicators: false) {
                            VStack {
                                DoseScheduleSubView(doseStatus: .scheduled)
                                    .padding(.top, UserManager.shared.userType == 0 ? 0 : 15)
                                    .padding(.bottom, 20)
                                    .fadeIn(delay: 0.3)
                                
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
        }
        .background(Color.gray5)
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

#Preview {
    DoseScheduleView()
}
