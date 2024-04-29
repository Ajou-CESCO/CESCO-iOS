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
    
//    var authService: Factory<AuthServiceType> {
//        Factory(self) {
//            AuthService()
//        }
//        .singleton
//    }
    var validationService: Factory<ValidationServiceType> {
        Factory(self) {
            ValidationService()
        }
        .singleton
    }
}
