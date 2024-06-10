//
//  CreateUserProfileViewModel.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 4/13/24.
//

import Combine

class CreateUserProfileViewModel: ObservableObject {
    
    /// 사용자 입력 단계를 추적하는 변수
    ///
    /// - 1: 전화번호
    /// - 2: 6자리 인증코드 입력
    /// - 3: 이름 입력
    /// - 4: 주민번호
    /// - 5: 보호자, 피보호자 선택
    @Published var step: Int = 1
    
    /// 각 단계에서의 텍스트
    var mainText: String {
        switch step {
        case 1:
            return "휴대폰 본인인증"
        case 2:
            return "문자로 발송된\n인증번호를 입력해주세요"
        case 3:
            return "이름은 무엇인가요?"
        case 4:
            return "주민등록번호를 입력해주세요"
        default:
            return "당신은 누구인가요?"
        }
    }
    
    var subText: String {
        switch step {
        case 1:
            return "본인 명의의 휴대폰 번호를 입력해주세요."
        case 2:
            return ""
        case 3:
            return "신분증에 표기되어 있는 실명을 입력해주세요."
        case 4:
            return "주민등록번호 7번째 자리까지 입력해주세요."
        default:
            return "본인에 대한 간단한 정보를 알려주세요."
        }
    }
    
    // MARK: - Methods
    
    /// 다음 단계로 이동하는 함수
    func nextStep() {
        if step < 2 {
            step += 1
        }
    }
    
    /// 이전 단계로 돌아가는 함수
    func previousStep() {
        if step > 1 {
            step -= 1
        }
    }
}
