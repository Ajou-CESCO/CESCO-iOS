//
//  RelationRequestView.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 5/19/24.
//

import SwiftUI

// MARK: - RelationRequestView

struct RelationRequestView: View {
    
    // MARK: - Properties
    
    @State private var isModalPresented = false
    @State private var selectedIndex: Int = 0
    @State private var isClinetSelectedRelation: Bool = false
    var finishSelectRelation: () -> Void
    
    let mockData: [RequestList] = [
        RequestList(requestId: 1, name: "이재현", phoneNumber: "0001"),
        RequestList(requestId: 2, name: "김서영", phoneNumber: "0002"),
        RequestList(requestId: 3, name: "박준호", phoneNumber: "0003"),
        RequestList(requestId: 4, name: "최윤아", phoneNumber: "0004"),
        RequestList(requestId: 5, name: "정다빈", phoneNumber: "0005"),
        RequestList(requestId: 6, name: "한지수", phoneNumber: "0006"),
        RequestList(requestId: 7, name: "유현석", phoneNumber: "0007"),
        RequestList(requestId: 8, name: "송민재", phoneNumber: "0008"),
        RequestList(requestId: 9, name: "김태희", phoneNumber: "0009"),
        RequestList(requestId: 10, name: "정우성", phoneNumber: "0010")
    ]
    
    // MARK: - body
    
    var body: some View {
        ScrollView {
            VStack {
                ForEach(0..<mockData.count, id: \.self) { index in
                    Button(action: {
                        self.selectedIndex = index
                        self.isModalPresented = true
                        print(self.selectedIndex)
                        print(index)
                        print(mockData[selectedIndex].name)
                    }, label: {
                        HStack {
                            Text(mockData[index].name)
                                .font(.h4Bold)
                                .foregroundStyle(Color.gray90)
                                .padding(.leading, 22)
                            
                            Spacer()
                            
                            Text(mockData[index].phoneNumber)
                                .font(.h5Regular)
                                .foregroundStyle(Color.gray70)
                                .padding(.trailing, 22)
                        }
                        
                    })
                    .frame(maxWidth: .infinity,
                           minHeight: 73, maxHeight: 73)
                    .background(Color.primary5)
                    .cornerRadius(15)
                    .fadeIn(delay: Double(index) * 0.1)
                    .padding(.bottom, 3)
                    .fullScreenCover(isPresented: $isModalPresented,
                                     content: {
                        CustomPopUpView(mainText: "\(mockData[selectedIndex].name) 님을 보호자로\n수락하시겠어요?",
                                        subText: "수락을 선택하면 \(mockData[selectedIndex].name) 님이 회원님의\n약 복용 현황과 건강 상태를 관리할 수 있어요.",
                                        leftButtonText: "거절할게요",
                                        rightButtonText: "수락할게요",
                                        leftButtonAction: { self.isModalPresented = false },
                                        rightButtonAction: {
                                            finishSelectRelation() })
                        .background(ClearBackgroundView())
                        .background(Material.ultraThin)
                        
                    })
                    .transaction { transaction in   // 모달 애니메이션 삭제
                        transaction.disablesAnimations = true
                    }
                }
                .padding(.bottom, 12)
            }
            .padding(.top, 30)
        }
    }
}
