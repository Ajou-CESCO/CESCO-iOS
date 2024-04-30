//
//  MyPageView.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 4/15/24.
//

import SwiftUI

struct MyPageView: View {
    
    // MARK: - Properties
    
    let mainText: [String] = ["예정된 횟수", "완료한 횟수", "미완료 횟수"]
    let subText: [String] = ["12회", "23회", "70회"]
    
    // MARK: - body
    
    var body: some View {
        
        VStack {
            VStack {
                Text("보호자")
                    .font(.body1Medium)
                    .foregroundStyle(Color.primary40)
                    .padding(.leading, 32)
                    .padding(.top, 10)
                    .padding(.bottom, 6)
                    .frame(maxWidth: .infinity,
                           alignment: .leading)
                    .fadeIn(delay: 0.1)
                
                Text("세스코 님, 안녕하세요!")
                    .font(.logo2Medium)
                    .foregroundStyle(Color.gray90)
                    .padding(.leading, 32)
                    .padding(.bottom, 36)
                    .frame(maxWidth: .infinity,
                           alignment: .leading)
                    .fadeIn(delay: 0.2)
                
                HStack {
                    Spacer()
                    
                    ForEach(0..<3, id: \.self) { index in
                        VStack {
                            Text(mainText[index])
                                .font(.body2Regular)
                                .foregroundStyle(Color.gray90)
                                .padding(.bottom, 5)
                            
                            Text(subText[index])
                                .font(.h5Bold)
                                .foregroundStyle(Color.gray70)
                        }
                        
                        Spacer()
                    }
                    
                }
                .frame(maxWidth: .infinity)
                .fadeIn(delay: 0.3)
            }
            .frame(maxWidth: .infinity,
                   minHeight: 264,
                   maxHeight: 264)
            .background(Color.white)
            
            SettingList()
        }
    }
}

// MARK: - SettingList

struct SettingList: View {
    
    @State private var isShowingDetailView = false
    @State private var selectedElement: SettingListElement?
    @ObservedObject var myPageViewModel: MyPageViewModel
    
    init() {
        self.myPageViewModel = MyPageViewModel()
    }
        
    var body: some View {
        ZStack {
            Color.gray5
            
            List {
                ForEach(SettingListElement.allCases, id: \.self) { element in
                    ZStack {
                        NavigationLink(destination: MyPageDetailView(settingListElement: element)) {
                            EmptyView()
                        }
                        .opacity(0.0)
                        .buttonStyle(PlainButtonStyle())
                        .background(Color.clear)
                        .listRowSeparator(.hidden)
                        
                        HStack {
                            Text(element.description)
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(Color.black)
                                .frame(height: 50)
                                .padding(.leading, 5)
                            
                            Spacer()
                        }
                    }
                }
            }
            .fadeIn(delay: 0.4)
            .listStyle(.sidebar)
            .background(Color.clear)
        }
    }
}

#Preview {
    MyPageView()
}
