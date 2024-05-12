//
//  DIContainer.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 4/11/24.
//

import Foundation
import SwiftUI

import Factory
import Moya

extension Container {
    // MARK: - ViewModel
    
    // MARK: - Moya
    
    // MARK: - Service
    
    var userService: Factory<UserServiceType> {
        Factory(self) {
            UserService()
        }
        .singleton
    }
    
    var authService: Factory<AuthServiceType> {
        Factory(self) {
            AuthService(provider: MoyaProvider<AuthAPI>())
        }
        .singleton
    }
    
    var validationService: Factory<ValidationServiceType> {
        Factory(self) {
            ValidationService()
        }
        .singleton
    }
    
    var planService: Factory<PlanServiceType> {
        Factory(self) {
            PlanService(provider: MoyaProvider<PlanAPI>())
        }
        .singleton
    }
    
    var etcService: Factory<EtcServiceType> {
        Factory(self) {
            EtcService(provider: MoyaProvider<EtcAPI>())
        }
        .singleton
    }
    
}
