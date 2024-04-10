//
//  Encodable+.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 4/9/24.
//

import Foundation

// MARK: - Encodable Extension

enum SerializationError: Error {
    case serializationFailed
}

extension Encodable {
    func asParameter() throws -> [String: Any] {
        let encoder = JSONEncoder()
        let data = try encoder.encode(self)
        
        let jsonObject = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
        
        guard let dictionary = jsonObject as? [String: Any] else {
            throw SerializationError.serializationFailed
        }
        
        return dictionary
    }
}
