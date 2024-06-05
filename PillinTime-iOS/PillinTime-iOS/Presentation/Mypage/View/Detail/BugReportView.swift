//
//  BugReportView.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 6/4/24.
//

import SwiftUI

import Moya

struct BugReportView: View {
    
    @ObservedObject var bugReportViewModel: BugReportViewModel = BugReportViewModel(etcService: EtcService(provider: MoyaProvider<EtcAPI>()))
    @State private var text: String = "여기에 버그를 입력하세요..."
    var onSubmit: (() -> Void)?
    @FocusState private var isFocused: Bool
        
    var body: some View {
        VStack {
            VStack {
                Text("앱에 버그가 있나요? 🥹")
                    .font(.logo2ExtraBold)
                    .foregroundStyle(Color.gray100)
                    .padding(.bottom, 10)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text("약속시간 서비스는 아직도 뚝딱뚝딱 중..⚒️")
                    .multilineTextAlignment(.leading)
                    .lineLimit(2)
                    .font(.body1Regular)
                    .foregroundStyle(Color.gray70)
                    .padding(.bottom, 20)
                    .lineSpacing(3)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
            }
            .onTapGesture {
                hideKeyboard()
            }
            
            ZStack {
                Color.white
                
                TextEditor(text: $text)
                    .cornerRadius(5)
                    .font(.body1Medium)
                    .foregroundStyle(Color.gray90)
                    .padding()
                    .onSubmit {
                        onSubmit?()
                    }
                    .focused($isFocused)
            }
            .cornerRadius(10)
            .frame(height: 150)
            
            Spacer()
            
            CustomButton(buttonSize: .regular,
                         buttonStyle: .filled,
                         action: {
                self.bugReportViewModel.$tapSubmitReport.send(text)
                hideKeyboard()
            }, content: {
                Text("제출하기")
            }, isDisabled: self.text.isEmpty,
            isLoading: self.bugReportViewModel.isNetworking)
        }
        .padding([.top, .leading, .trailing], 32)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.isFocused = true
            }
        }
    }
}

#Preview {
    BugReportView()
}
