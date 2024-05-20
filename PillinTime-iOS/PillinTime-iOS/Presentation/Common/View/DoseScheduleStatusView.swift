//
//  DoseScheduleStatusView.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 5/2/24.
//

import SwiftUI

import CodeScanner
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
                                
                                HStack {
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
                       minHeight: 45,
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
            dateFormatter.dateFormat = "a h시"
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

// MARK: - AddPillCaseView

struct AddPillCaseView: View {
    
    // MARK: - Properties
    
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var addPillCaseViewModel: AddPillCaseViewModel
    @State private var textInput: String = String()
    @State private var showQRCodeScanningView: Bool = false
    @State private var scannedCode: String?
    var selectedManagerId: Int
    
    @ObservedObject var toastManager = Container.shared.toastManager.resolve()
    
    // MARK: - Initializer
    
    init(selectedManagerId: Int) {
        self.selectedManagerId = selectedManagerId
        self.addPillCaseViewModel = AddPillCaseViewModel(caseService: CaseService(provider: MoyaProvider<CaseAPI>()))
    }
    
    // MARK: - body
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                CustomNavigationBar()
                
                VStack(alignment: .leading) {
                    Text(addPillCaseViewModel.mainText)
                        .font(.logo2ExtraBold)
                        .foregroundStyle(Color.gray100)
                        .padding(.bottom, 5)
                        .fadeIn(delay: 0.1)
                    
                    Text(addPillCaseViewModel.subText)
                        .font(.body1Regular)
                        .foregroundStyle(Color.gray70)
                        .fadeIn(delay: 0.2)
                    
                    CustomTextInput(placeholder: addPillCaseViewModel.placeholder,
                                    text: $addPillCaseViewModel.infoState.serialNumber,
                                    isError: .constant(false),
                                    errorMessage: addPillCaseViewModel.infoErrorState.serialNumberErrorMessage,
                                    textInputStyle: .text)
                        .fadeIn(delay: 0.3)
                    
                    Button(action: {
                        self.showQRCodeScanningView = true
                    }, label: {
                        Text("QR 코드로 등록하기")
                            .font(.body2Medium)
                            .foregroundStyle(Color.gray90)
                    })
                    .fadeIn(delay: 0.4)
                    
                    Spacer()
                    
                    CustomButton(buttonSize: .regular,
                                 buttonStyle: .filled,
                                 action: {
                        hideKeyboard()
                        requestToAddPillCase(serialNumber: addPillCaseViewModel.infoState.serialNumber)
                    }, content: {
                        Text("확인")
                    }, isDisabled: !addPillCaseViewModel.infoErrorState.serialNumberErrorMessage.isEmpty || addPillCaseViewModel.infoState.serialNumber.isEmpty,
                                 isLoading: addPillCaseViewModel.isNetworking)
                        .fadeIn(delay: 0.4)
                }
                .padding([.leading, .trailing], 33)
                
                Spacer()
            }
        }
        .fullScreenCover(isPresented: $showQRCodeScanningView,
                         content: {
            ZStack {
                VStack {
                    HStack {
                        Text("약통 QR 코드 스캔")
                            .font(.body2Medium)
                            .foregroundStyle(Color.gray90)
                    }
                    
                    ZStack(alignment: .topTrailing) {
                        CodeScannerView(codeTypes: [.qr]) { response in
                            switch response {
                            case .success(let result):
                                scannedCode = result.string
                                showQRCodeScanningView = false
                                requestToAddPillCase(serialNumber: scannedCode ?? "nil")
                            case .failure(let error):
                                print("스캔 실패: \(error)")
                                self.toastManager.showToast(description: "스캔에 실패했습니다.")
                            }
                        }
                        
                        Button(action: {
                            self.showQRCodeScanningView = false
                        }, label: {
                            Image(systemName: "xmark.circle.fill")
                                .resizable()
                                .foregroundStyle(Color.white)
                                .frame(width: 20, height: 20)
                        })
                        .padding()
                    }
                    
                }
                
                VStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(.clear)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .strokeBorder(
                                    Color.primary60,
                                    lineWidth: 1
                                )
                        )
                        .frame(width: 200, height: 200)
                    
                    Text("사각형 안에 QR 코드를 맞춰주세요")
                        .font(.body2Medium)
                        .foregroundStyle(Color.primary60)
                }
               
            }
            
        })
        .onChange(of: addPillCaseViewModel.isNetworkSucceed, {
            self.toastManager.showToast(description: "약통 등록을 성공했습니다.")
            withAnimation(nil) {
                dismiss()
            }
        })

    }
    
    private func requestToAddPillCase(serialNumber: String) {
        self.addPillCaseViewModel.$tapAddPillCaseButton.send(PillCaseInfoState(ownerId: self.selectedManagerId,
                                                                              serialNumber: serialNumber))
    }
}
