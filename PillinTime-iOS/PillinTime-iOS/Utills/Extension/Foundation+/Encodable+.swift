//
//  Encodable+.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 4/9/24.
//

import Foundation

// MARK: - Encodable Extension

extension Encodable {
    
  func asParameter() throws -> [String: Any] {
    let data = try JSONEncoder().encode(self)
    guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
            as? [String: Any] else {
        throw NSError()
    }
    return dictionary
  }
}
