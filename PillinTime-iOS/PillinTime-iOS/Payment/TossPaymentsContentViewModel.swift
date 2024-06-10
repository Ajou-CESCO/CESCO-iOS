//
//  TossPaymentsContentViewModel.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 6/9/24.
//

import SwiftUI
import TossPayments
import Moya
import Factory
import Combine

struct SuccessPaymentState {
    var paymentKey: String = String()
    var orderId: String = String()
    var amount: Int = Int()
}

class TossPaymentsContentViewModel: ObservableObject {
    let widget = PaymentWidget(clientKey: Config.tossCustomerApiKey, customerKey: Config.tossCustomerApiKey)

    @Published var isShowing: Bool = false

    @Published var onSuccess: TossPaymentsResult.Success?
    @Published var onFail: TossPaymentsResult.Fail?
    
    @Published var paymentInfo: RequestPaymentInfoResponseModelResult?
    
    @Published var successPaymentState: SuccessPaymentState = SuccessPaymentState()

    @Injected(\.paymentService) var paymentService: PaymentServiceType
    
    @Subject var requestPaymentInfo: Void = ()
    @Subject var requestSuccessPayment: Void = ()
    
    private var cancellables = Set<AnyCancellable>()
    
    init(paymentService: PaymentService) {
        self.paymentService = paymentService
        bindState()
    }
    
    private func bindState() {
        $requestPaymentInfo.sink { _ in
            self.requestPaymentInfoToServer()
        }
        .store(in: &cancellables)
        
        $requestSuccessPayment.sink { _ in
            self.requestSuccessPaymentToServer()
        }
        .store(in: &cancellables)
    }
    
    // MARK: - Methods
    
    func requestPaymentInfoToServer() {
        print("사용자 결제 정보 요청 시작")
        paymentService.requestPaymentInfo(memberId: UserManager.shared.memberId ?? 0)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                switch completion {
                case .finished:
                    print("사용자 결제 정보 요청 완료")
                case .failure(let error):
                    print("사용자 결제 정보 요청 실패: \(error)")
                }
            }, receiveValue: { [weak self] result in
                guard let self = self else { return }
                paymentInfo = result.result
                print(paymentInfo)
            })
            .store(in: &cancellables)
    }
    
    func requestSuccessPaymentToServer() {
        print("사용자 결제 성공 요청 시작")
        paymentService.requestSuccessPayment(paymentKey: successPaymentState.paymentKey,
                                             orderId: successPaymentState.orderId,
                                             amount: successPaymentState.amount)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                switch completion {
                case .finished:
                    print("사용자 결제 성공 요청 완료")
                case .failure(let error):
                    print("사용자 결제 성공 요청 실패: \(error)")
                }
            }, receiveValue: { [weak self] result in
                guard let self = self else { return }
            })
            .store(in: &cancellables)
    }
}

extension TossPaymentsContentViewModel: TossPaymentsDelegate {
    func handleSuccessResult(_ success: TossPaymentsResult.Success) {
        onSuccess = success
    }

    func handleFailResult(_ fail: TossPaymentsResult.Fail) {
        onFail = fail
    }
}
