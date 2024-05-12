//
//  MyPageDetailView.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 4/15/24.
//

import SwiftUI

// 이후 다른 곳으로 이동할 것
@frozen
enum UserProfile {
    case name
    case phoneNumber
    case ssn
    var description: String {
        switch self {
        case .name:
            return "성명"
        case .phoneNumber:
            return "휴대폰 번호"
        case .ssn:
            return "주민등록번호"
        }
    }
    static let allCases: [UserProfile] = [
        .name,
        .phoneNumber,
        .ssn
    ]
}

// MARK: - MyPageDetailView

struct MyPageDetailView: View {
    
    // MARK: - Properties
    
    @State var isEditing: Bool = false
    @State var settingListElement: SettingListElement
    
    // MARK: - body
    
    var body: some View {
        
        VStack {
            CustomNavigationBar(title: settingListElement.description)
            
            switch settingListElement {
            case .managementMyInformation:
                ManagementMyInformationView(isEditing: $isEditing)
            case .subscriptionPaymentHistory:
                SubscriptionPaymentHistoryView()
            case .customerServiceCenter:
                CustomerServiceCenterView()
            case .withdrawal:
                WithdrawalView()
            case .clientManage:
                ClientManageView()
            }
            
            Spacer()
        }
        .navigationBarHidden(true)
    }
}

// MARK: - ManagementMyInformationView

struct ManagementMyInformationView: View {
    
    // MARK: - Properties
    
    @Binding var isEditing: Bool
    @State private var showToast: Bool = false

    @State private var textInputType: UserProfile?   // 입력하는 타입에 따라 분류
    @ObservedObject var validationViewModel: UserProfileValidationViewModel
    @ObservedObject var myPageViewModel: MyPageViewModel
    
    @State private var name: String = (UserManager.shared.name ?? "null")
    @State private var phoneNumber: String = (UserManager.shared.phoneNumber ?? "null")
    @State private var ssn: String = (UserManager.shared.ssn ?? "null")
     
    // MARK: - Initializer

    init(isEditing: Binding<Bool>) {
        self._isEditing = isEditing

        let validationService = ValidationService()
        self.validationViewModel = UserProfileValidationViewModel(validationService: validationService)
        self.myPageViewModel = MyPageViewModel()
        self.validationViewModel.bindEvent()
        self.validationViewModel.setInitValue()
    }
    
    // MARK: - body
    
    var body: some View {
        VStack {
            Text("기본 정보")
                .font(.h5Bold)
                .foregroundStyle(Color.gray90)
                .padding(.leading, 33)
                .padding(.top, 30)
                .frame(maxWidth: .infinity,
                       alignment: .leading)
            
            List {
                ForEach(UserProfile.allCases, id: \.self) { element in
                    if !isEditing { // 수정 중이 아닐 때
                        HStack {
                            Text(element.description)
                                .font(.body2Medium)
                                .foregroundStyle(Color.gray70)
                                .frame(width: 100,
                                       alignment: .leading)
                            
                            Text(setTextInputData(element: element))
                                .font(.h5Medium)
                                .foregroundStyle(Color.gray90)
                        }
                        .padding()
                    } else {    // 수정 중일 때
                        VStack {
                            Text(element.description)
                                .font(.body2Medium)
                                .foregroundStyle(Color.gray70)
                                .frame(maxWidth: .infinity,
                                       alignment: .leading)
                                .padding(.top, 5)
                            
                            setCustomTextInput(textInputType: element)
                            
                        }
                        .padding([.leading, .trailing], 8)
                    }
                }
            }
            .listStyle(.plain)
            .background(Color.clear)
            
            if showToast {
                ToastView(description: "정보 수정이 완료되었어요.", show: $showToast)
            }
            
            CustomButton(buttonSize: .regular,
                         buttonStyle: .filled,
                         action: {
                isEditing.toggle()
                updateUserProfile()
                if !isEditing { self.showToast = true }
            }, content: {
                isEditing ? Text("수정 완료하기") : Text("수정하기")
            }, isDisabled: false)
            .padding([.leading, .trailing], 32)
        }
    }
    
    /// 수정 전: 초기값 return func
    private func setTextInputData(element: UserProfile) -> String {
        switch element {
        case .name:
            return self.name
        case .phoneNumber:
            return self.phoneNumber
        case .ssn:
            return self.ssn.prefix(8) + "●●●●●●"
        }
        
    }
    
    /// 수정 중: custom text input setting
    private func setCustomTextInput(textInputType: UserProfile) -> CustomTextInput {
        switch textInputType {
        case .name:
            return CustomTextInput(placeholder: "이름 입력",
                                   text: $validationViewModel.infoState.name,
                                   isError: .isErrorBinding(for: $validationViewModel.infoErrorState.nameErrorMessage),
                                   errorMessage: validationViewModel.infoErrorState.nameErrorMessage,
                                   textInputStyle: .text)
        case .phoneNumber:
            return CustomTextInput(placeholder: "휴대폰 번호 입력",
                                   text: $validationViewModel.infoState.phoneNumber,
                                   isError: .isErrorBinding(for: $validationViewModel.infoErrorState.phoneNumberErrorMessage),
                                   errorMessage: validationViewModel.infoErrorState.phoneNumberErrorMessage,
                                   textInputStyle: .phoneNumber)
        case .ssn:
            return CustomTextInput(placeholder: "주민등록번호 입력",
                                   text: $validationViewModel.infoState.ssn,
                                   isError: .isErrorBinding(for: $validationViewModel.infoErrorState.ssnErrorMessage),
                                   errorMessage: validationViewModel.infoErrorState.ssnErrorMessage,
                                   textInputStyle: .ssn)
        }
    }
    
    /// 수정 후: UserDefault 및 서버 반영 (추후)
    private func updateUserProfile() {
        let userManager = UserManager.shared
        userManager.name = validationViewModel.infoState.name
        self.name = validationViewModel.infoState.name
        userManager.phoneNumber = validationViewModel.infoState.phoneNumber
        self.phoneNumber = validationViewModel.infoState.phoneNumber
        userManager.ssn = validationViewModel.infoState.ssn
        self.ssn = validationViewModel.infoState.ssn
    }
}

// MARK: - SubscriptionPaymentHistoryView

struct SubscriptionPaymentHistoryView: View {
    var body: some View {
        /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Hello, world!@*/Text("Hello, world!")/*@END_MENU_TOKEN@*/
    }
}

// MARK: - CustomerServiceCenterView

struct CustomerServiceCenterView: View {
    var body: some View {
        /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Hello, world!@*/Text("Hello, world!")/*@END_MENU_TOKEN@*/
    }
}

// MARK: - WithdrawalView

struct WithdrawalView: View {
    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading){
                Text("정말 탈퇴하시겠어요?")
                    .font(.logo2ExtraBold)
                    .foregroundStyle(Color.gray100)
                    .padding(.top, 50)
                
                Text("계정을 삭제하는 경우\n - 피보호자와의 케어 내역이 영구적으로 삭제되며\n - 동일한 사용자 이름으로 가입하거나 해당 사용자 이름을 다른 계정에 추가할 수 없습니다.")
                    .font(.body2Regular)
                    .foregroundStyle(Color.gray70)
                    .padding(.top, 12)
                    .lineSpacing(5)
                
                Text("약속시간을 사용하신 경험이 도움이 되셨길 바랍니다.\n감사합니다.")
                    .font(.body2Regular)
                    .foregroundStyle(Color.gray70)
                    .padding(.top, 12)
                    .lineSpacing(5)
            }
            .padding([.leading, .trailing], 33)
                
            Spacer()
            
            CustomButton(buttonSize: .regular,
                         buttonStyle: .disabled,
                         action: {
                
            }, content: {
                Text("탈퇴하기")
            }, isDisabled: false)
            .padding([.leading, .trailing], 32)
        }
    }
}

// MARK: - ClientManageView

struct ClientManageView: View {
    
    // MARK: - Properties

    @ObservedObject var clientListViewModel = ClientListViewModel()
    @State var isDeletePopUp: Bool = false
    @State var clientIndex: Int = 0
    
    // MARK: - body
    
    var body: some View {
        VStack {
            Text("총 10명")
                .font(.h5Bold)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 32)
                .padding([.top, .bottom], 20)
            
            List {
                ForEach(0..<clientListViewModel.clients.count, id: \.self) { index in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(clientListViewModel.clients[index].userName)
                                .font(.h5Bold)
                                .foregroundStyle(Color.gray90)
                                .padding(.bottom, 3)

                            Text(clientListViewModel.clients[index].userPhone)
                                .font(.body2Medium)
                                .foregroundStyle(Color.gray70)
                        }
                        
                        Spacer()
                        
                        Image(clientListViewModel.clients[index].caseId.isEmpty ? "ic_cabnet_disconnected" : "ic_cabnet_connected")
                            .resizable()
                            .frame(width: 50, height: 50)
                    }
                    .swipeActions {
                        Button("삭제") {
                            self.isDeletePopUp = true
                            self.clientIndex = index
                        }
                        .tint(.error90)
                    }
                    .ignoresSafeArea(edges: .all)
                    .frame(height: 70)
                    .padding([.leading, .trailing], 30)
                    .fullScreenCover(isPresented: $isDeletePopUp,
                                     content: {
                        CustomPopUpView(mainText: "\(clientListViewModel.clients[clientIndex].userName) 님을\n삭제하시겠어요?",
                                        subText: "삭제하면 \(clientListViewModel.clients[clientIndex].userName) 님은 새로운 보호자가 케어를\n요청할 때까지 서비스를 이용할 수 없어요.",
                                        leftButtonText: "취소할래요",
                                        rightButtonText: "삭제할래요",
                                        leftButtonAction: {
                            
                        },
                                        rightButtonAction: {
                            
                        })
                        .background(ClearBackgroundView())
                        .background(Material.ultraThin)
                       
                    })
                    .transaction { transaction in   // 모달 애니메이션 삭제
                        transaction.disablesAnimations = true
                    }
                }
                
            }
            .listStyle(.plain)
        }
        
    }
}

#Preview {
    ClientManageView()
}
