//
//  BugReportView.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 6/4/24.
//

import SwiftUI
import TossPayments
import Moya
import Factory

struct TossPaymentsContentView: View {
    @State private var showTossPaymentView: Bool = false
    @StateObject var viewModel = TossPaymentsContentViewModel(paymentService: PaymentService(provider: MoyaProvider<PaymentAPI>()))
    @ObservedObject var toastManager = Container.shared.toastManager.resolve()
    @State var tag: Int?
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack(alignment: .leading) {
                Text("프리미엄 이용권 결제")
                    .font(.logo2ExtraBold)
                    .foregroundStyle(Color.gray100)
                    .padding(.top, 50)
                
                Text("해당 이용권을 최초 1회 결제하고 나면, \n피보호자를 제한 없이 등록할 수 있어요.")
                    .font(.body2Regular)
                    .foregroundStyle(Color.gray70)
                    .padding(.top, 12)
                    .lineSpacing(5)
                
                Text("가격: 30,000원")
                    .font(.body2Regular)
                    .foregroundStyle(Color.gray70)
                    .padding(.top, 12)
                    .lineSpacing(5)
                
                Spacer()
                
                CustomButton(buttonSize: .regular,
                             buttonStyle: .filled,
                             action: {
                    self.showTossPaymentView = true
                }, content: {
                    Text(UserManager.shared.isSubscriber ?? true ? "이미 결제했어요" : "결제하기")
                }, isDisabled: UserManager.shared.isSubscriber ?? true)
            }
            .padding([.leading, .trailing], 33)
            
            if toastManager.show {
                ToastView(description: toastManager.description, show: $toastManager.show)
                    .padding(.bottom, 70)
                    .zIndex(1)
            }
        }
        .fullScreenCover(isPresented: $showTossPaymentView, content: {
            TossPaymentsView(clientKey: Config.tossCustomerApiKey,
                             paymentMethod: .카드,
                             paymentInfo: DefaultPaymentInfo(
                                amount: 30000,
                                orderId: viewModel.paymentInfo?.orderID ?? "",
                                orderName: "프리미엄 이용권",
                                customerName: UserManager.shared.name ?? ""),
                isPresented: .constant(true))
                .onSuccess({ paymentKey, orderId, amount in
                    print(paymentKey, orderId, amount)
                    viewModel.successPaymentState = SuccessPaymentState(paymentKey: paymentKey,
                                                                        orderId: orderId,
                                                                        amount: Int(amount))
                    viewModel.$requestSuccessPayment.send()
                    self.showTossPaymentView = false
                    self.toastManager.showToast(description: "결제에 성공했어요.")
                })
                .onFail({ errorCode, errorMessage, orderId in
                    print(errorCode)
                    print(errorMessage)
                    print(orderId)
                    self.showTossPaymentView = false
                    self.toastManager.showToast(description: "결제를 취소했어요.")
                })
        })
        .onAppear {
            self.viewModel.$requestPaymentInfo.send()
        }
    }
}
