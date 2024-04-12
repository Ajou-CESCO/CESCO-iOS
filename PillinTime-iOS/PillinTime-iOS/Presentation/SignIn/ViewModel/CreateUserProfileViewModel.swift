//
//  CreateUserProfileViewModel.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 4/13/24.
//

import Combine

class CreateUserProfileViewModel: ObservableObject {
    
    /// 사용자 입력 단계를 추적하는 변수
    /// - 1: 보호자, 피보호자 선택
    /// - 2: 이름 입력
    /// - 3: 주민번호
    @Published var step: Int = 1
    
    /// 각 단계에서의 텍스트
    var mainText: String {
        switch step {
        case 1:
            return "당신은 누구인가요?"
        case 2:
            return "이름은 무엇인가요?"
        case 3:
            return "주민등록번호를 입력해주세요."
        default:
            return String()
        }
    }
    
    var subText: String {
        switch step {
        case 1:
            return "본인에 대한 간단한 정보를 알려주세요."
        case 2:
            return "신분증에 표기되어 있는 실명을 입력해주세요."
        case 3:
            return "주민등록번호 7번째 자리까지 입력해주세요."
        default:
            return String()
        }
    }
    
    // MARK: - Methods
    
    /// 다음 단계로 이동하는 함수
    func nextStep() {
        if step < 2 {
            step += 1
        }
    }
}
