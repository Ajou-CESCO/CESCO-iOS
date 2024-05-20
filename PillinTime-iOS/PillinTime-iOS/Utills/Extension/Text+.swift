//
//  Text+.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 4/15/24.
//

import SwiftUI

extension Text {
    
    /// 텍스트 안에 여러 컬러를 넣어야 하는 경우 사용하는 함수입니다.
    /// Reference: https://velog.io/@yimkeul/SwiftUI-Text-%EB%82%B4%EB%B6%80-%ED%8A%B9%EC%A0%95-%EA%B8%80%EC%9E%90%EB%A7%8C-%EC%83%89%EC%83%81-%EC%A0%81%EC%9A%A9
    static func multiColoredText(_ originalText: String, coloredSubstrings: [(String, Color)]) -> Text {
        var result = Text("")
        var lastIndex = originalText.startIndex
        
        for (substring, color) in coloredSubstrings.sorted(by: { $0.0.count > $1.0.count }) { // 더 긴 문자열 우선적으로 처리
            while let range = originalText.range(of: substring, range: lastIndex..<originalText.endIndex, locale: Locale.current) {
                let beforeRange = originalText[lastIndex..<range.lowerBound]
                result = result + Text(String(beforeRange))
                result = result + Text(String(substring)).foregroundColor(color)
                lastIndex = range.upperBound
            }
        }
        
        if lastIndex < originalText.endIndex {
            let remainingText = originalText[lastIndex...]
            result = result + Text(String(remainingText))
        }
        
        return result
    }
}
