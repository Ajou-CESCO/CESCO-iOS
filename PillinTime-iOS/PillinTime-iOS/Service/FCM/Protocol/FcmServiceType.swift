//
//  FcmServiceType.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 5/26/24.
//

import Foundation
import Combine
import Moya

/// FCM 관련 Service입니다.
protocol FcmServiceType {
    
    /// 사용자의 FCM 토큰을 서버에 전송합니다.
    ///
    /// - Parameters:
    ///     - fcmToken: 푸시 알림을 위한 토큰입니다.
    /// - Returns:
    ///     - BaseResponse
    func registerToken(fcmToken: String) -> AnyPublisher<BaseResponse<BlankData>, PillinTimeError>
    
    /// 특정 사용자 id에 대하여 푸시 알림을 보냅니다.
    ///
    /// - Parameters:
    ///     - targetId: 푸시 알림을 보낼 타겟의 id입니다.
    /// - Returns:
    ///     - BaseResponse
    func requestPushAlarm(targetId: Int) -> AnyPublisher<BaseResponse<BlankData>, PillinTimeError>
}
