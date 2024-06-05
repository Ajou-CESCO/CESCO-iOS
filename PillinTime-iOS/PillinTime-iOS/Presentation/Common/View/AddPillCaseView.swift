//
//  AddPillCaseView.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 6/5/24.
//

import SwiftUI

import Factory
import Moya
import CodeScanner

// MARK: - AddPillCaseView

struct AddPillCaseView: View {
    
    // MARK: - Properties
    
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var addPillCaseViewModel: AddPillCaseViewModel
    @State private var textInput: String = String()
    @State private var showQRCodeScanningView: Bool = false
    @State private var scannedCode: String?
    var selectedMemberId: Int
    
    @ObservedObject var toastManager = Container.shared.toastManager.resolve()
    
    // MARK: - Initializer
    
    init(selectedMemberId: Int) {
        self.selectedMemberId = selectedMemberId
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
                                    textInputStyle: .text,
                                    onSubmit: {
                        requestToAddPillCase(serialNumber: addPillCaseViewModel.infoState.serialNumber)
                    })
                        .fadeIn(delay: 0.3)
                    
                    Button(action: {
                        self.showQRCodeScanningView = true
                    }, label: {
                        Text("QR 코드로 등록하기")
                            .font(.body2Medium)
                            .foregroundStyle(Color.gray90)
                            .padding(3)
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
                    }, isDisabled: addPillCaseViewModel.infoState.serialNumber.isEmpty,
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
                                .frame(width: 30, height: 30)
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
        self.addPillCaseViewModel.$tapAddPillCaseButton.send(PillCaseInfoState(ownerId: self.selectedMemberId,
                                                                               serialNumber: serialNumber))
    }
}
