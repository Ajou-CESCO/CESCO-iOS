//
//  ClientManageView.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 5/15/24.
//

import SwiftUI 

import Moya
import Factory

struct SelectedRelation {
    var name: String = String()
    var ssn: String = String()
    var phone: String = String()
}

// MARK: - ClientManageView

struct ClientManageView: View {
    
    // MARK: - Properties

    @ObservedObject var homeViewModel = Container.shared.homeViewModel.resolve()
    @State var isDeletePopUp: Bool = false
    @State var isRequestRelationPopUp: Bool = false
    @State var showInformationView: Bool = false
    @State var selectedRelation: SelectedRelation = SelectedRelation()
    @State var showToastView: Bool = false
    
    // MARK: - body
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Text("총 \(homeViewModel.relationLists.count)명")
                        .font(.h5Bold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding([.top, .bottom], 20)

                    Button(action: {
                        self.isRequestRelationPopUp = true
                    }, label: {
                        Image(systemName: "person.crop.circle.badge.plus")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30)
                    })
                    .foregroundColor(.gray60)
                }
                .padding([.leading, .trailing], 32)
        
                List {
                    ForEach(homeViewModel.relationLists, id: \.memberID) { relation in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(relation.memberName)
                                    .font(.h5Bold)
                                    .foregroundStyle(Color.gray90)
                                    .padding(.bottom, 3)
                                
                                Text(relation.memberPhone)
                                    .font(.body2Medium)
                                    .foregroundStyle(Color.gray70)
                            }
                            
                            Spacer()
                            
                            Image(relation.cabinetID == 0 ? "ic_cabnet_disconnected" : "ic_cabnet_connected")
                                .resizable()
                                .frame(width: 50, height: 50)
                        }
                        .onTapGesture {
                            self.selectedRelation = SelectedRelation(name: relation.memberName,
                                                                     ssn: relation.memberPhone,
                                                                     phone: relation.memberPhone)
                            self.showInformationView = true
                        }
                        .swipeActions {
                            Button("삭제") {
                                self.isDeletePopUp = true
                                self.selectedRelation = SelectedRelation(name: relation.memberName,
                                                                         ssn: relation.memberPhone,
                                                                         phone: relation.memberPhone)
                            }
                            .tint(.error90)
                        }
                        .ignoresSafeArea(edges: .all)
                        .frame(height: 70)
                        .padding([.leading, .trailing], 30)
                    }
                    
                }
                .ignoresSafeArea(edges: .bottom)
                .listStyle(.plain)
                .fadeIn(delay: 0.1)
                
                if showToastView {
                    ToastView(description: "보호 관계를 요청했어요.", show: $showToastView)
                        .padding(.bottom, 20)
                }
            }
        }
        .fullScreenCover(isPresented: $isRequestRelationPopUp,
                         content: {
            RequestRelationPopUpView(onNetworkSuccess: {
                self.showToastView = true
            })
                .background(ClearBackgroundView())
                .background(Material.ultraThin)
        })
        .fullScreenCover(isPresented: $isDeletePopUp,
                         content: {
            CustomPopUpView(mainText: "\(selectedRelation.name) 님을\n삭제하시겠어요?",
                            subText: "삭제하면 \(selectedRelation.name) 님은 새로운 보호자가 케어를\n요청할 때까지 서비스를 이용할 수 없어요.",
                            leftButtonText: "취소할래요",
                            rightButtonText: "삭제할래요",
                            leftButtonAction: {
                
            },
                            rightButtonAction: {
                
            })
            .background(ClearBackgroundView())
            .background(Material.ultraThin)
           
        })
        .sheet(isPresented: $showInformationView,
               content: {
            ManagementMyInformationView(name: selectedRelation.name,
                                        phoneNumber: selectedRelation.phone,
                                        ssn: selectedRelation.ssn)
        })
        .transaction { transaction in   // 모달 애니메이션 삭제
            transaction.disablesAnimations = true
        }
    }
}

// MARK: - RequestRelationPopUpView

struct RequestRelationPopUpView: View {
    
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var validationViewModel: UserProfileValidationViewModel
    @ObservedObject var requestRelationViewModel: RequestRelationViewModel
    @State private var isButtonDisabled: Bool = true
    
    let onNetworkSuccess: () -> Void  // 클로저 추가
    
    init(onNetworkSuccess: @escaping () -> Void) {
        self.onNetworkSuccess = onNetworkSuccess
        self.validationViewModel = UserProfileValidationViewModel(validationService: ValidationService())
        self.requestRelationViewModel = RequestRelationViewModel(requestService: RequestService(provider: MoyaProvider<RequestAPI>()))
        self.validationViewModel.bindEvent()
    }
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                Button(action: {
                    withAnimation(nil) {
                        dismiss()
                    }
                }, label: {
                    Image(systemName: "xmark")
                        .resizable()
                        .frame(width: 15, height: 15)
                        .foregroundColor(.gray90)
                        .padding([.leading, .trailing, .top], 5)
                })
                .frame(maxWidth: .infinity, alignment: .trailing)
                
                Text("추가할 피보호자의\n휴대폰 번호를 입력해주세요")
                    .font(.h4Bold)
                    .foregroundStyle(Color.gray90)
                    .padding(.bottom, 20)
                    .lineSpacing(3)
            
                CustomTextInput(placeholder: "휴대폰 번호 입력",
                                text: $validationViewModel.infoState.phoneNumber,
                                isError: .isErrorBinding(for: $validationViewModel.infoErrorState.phoneNumberErrorMessage),
                                errorMessage: validationViewModel.infoErrorState.phoneNumberErrorMessage,
                                textInputStyle: .phoneNumber)
                .padding(.bottom, 40)
                
                CustomButton(buttonSize: .regular,
                             buttonStyle: .filled,
                             action: {
                    hideKeyboard()
                    self.requestRelationViewModel.$tapRequestButton.send(validationViewModel.infoState.phoneNumber)
                }, content: {
                    Text("요청하기")
                }, isDisabled: isButtonDisabled
                , isLoading: requestRelationViewModel.isNetworking)
            }
            .padding([.leading, .trailing], 27)
            .padding(.top, 29)
            .padding(.bottom, 20)
            
        }
        .background(Color.white)
        .cornerRadius(12)
        .padding()
        .fadeIn(delay: 0.1)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onReceive(validationViewModel.$infoErrorState) { _ in
            updateButtonState()
        }
        .onReceive(validationViewModel.$infoState, perform: { _ in
            updateButtonState()
        })
        .onTapGesture {
            hideKeyboard()
        }
        .onChange(of: requestRelationViewModel.isNetworkSucceed, {
            onNetworkSuccess()
            withAnimation(nil) {
                dismiss()
            }
        })
    }
    
    private func updateButtonState() {
        self.isButtonDisabled = !validationViewModel.infoErrorState.phoneNumberErrorMessage.isEmpty || validationViewModel.infoState.phoneNumber.isEmpty
    }
}
