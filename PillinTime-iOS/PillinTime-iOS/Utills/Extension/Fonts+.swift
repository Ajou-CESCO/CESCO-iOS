//
//  Fonts+.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 4/9/24.
//

import Foundation
import SwiftUI

/// Reference: https://jacobzivandesign.com/technology/custom-dynamic-fonts-in-swift-ui/

extension Font {
    // OAGothic
    static let logo1Medium = customFont(.oaGothicExtraBold, size: 36)
    static let logo1ExtraBold = customFont(.oaGothicMedium, size: 36)
    
    static let logo2Medium = customFont(.oaGothicExtraBold, size: 24)
    static let logo2ExtraBold = customFont(.oaGothicMedium, size: 24)
    
    static let logo3Medium = customFont(.oaGothicExtraBold, size: 20)
    static let logo3ExtraBold = customFont(.oaGothicMedium, size: 20)
    
    static let logo4Medium = customFont(.oaGothicExtraBold, size: 16)
    static let logo4ExtraBold = customFont(.oaGothicMedium, size: 16)
    
    static let logo5Medium = customFont(.oaGothicExtraBold, size: 12)
    static let logo5ExtraBold = customFont(.oaGothicMedium, size: 12)
    
    // Pretendard
    static let h1Regular = customFont(.pretendardRegular, size: 48)
    static let h1Medium = customFont(.pretendardMedium, size: 48)
    static let h1Bold = customFont(.pretendardBold, size: 48)
    
    static let h2Regular = customFont(.pretendardRegular, size: 34)
    static let h2Medium = customFont(.pretendardMedium, size: 34)
    static let h2Bold = customFont(.pretendardBold, size: 34)
    
    static let h3Regular = customFont(.pretendardRegular, size: 28)
    static let h3Medium = customFont(.pretendardMedium, size: 28)
    static let h3Bold = customFont(.pretendardBold, size: 28)
    
    static let h4Regular = customFont(.pretendardRegular, size: 24)
    static let h4Medium = customFont(.pretendardMedium, size: 24)
    static let h4Bold = customFont(.pretendardBold, size: 24)
    
    static let h5Regular = customFont(.pretendardRegular, size: 20)
    static let h5Medium = customFont(.pretendardMedium, size: 20)
    static let h5Bold = customFont(.pretendardBold, size: 20)
    
    static let body1Regular = customFont(.pretendardRegular, size: 16)
    static let body1Medium = customFont(.pretendardMedium, size: 16)
    static let body1Bold = customFont(.pretendardBold, size: 16)
    
    static let body2Regular = customFont(.pretendardRegular, size: 14)
    static let body2Medium = customFont(.pretendardMedium, size: 14)
    static let body2Bold = customFont(.pretendardBold, size: 14)
    
    static let caption1Regular = customFont(.pretendardRegular, size: 12)
    static let caption1Medium = customFont(.pretendardMedium, size: 12)
    static let caption1Bold = customFont(.pretendardBold, size: 12)
    
    static let caption2Regular = customFont(.pretendardRegular, size: 11)
    static let caption2Medium = customFont(.pretendardMedium, size: 11)
    static let caption2Bold = customFont(.pretendardBold, size: 11)
}

extension Font.TextStyle {
    var size: CGFloat {
        switch self {
        case .largeTitle: return 60
        case .title: return 48
        case .title2: return 34
        case .title3: return 24
        case .headline, .body: return 18
        case .subheadline, .callout: return 16
        case .footnote: return 14
        case .caption, .caption2: return 12
        @unknown default:
            return 8
        }
    }
}

enum FontName: String {
    case oaGothicExtraBold = "OAGothic-ExtraBold"
    case oaGothicMedium = "OAGothic-Medium"
    case pretendardMedium = "Pretendard-Medium"
    case pretendardRegular = "Pretendard-Regular"
    case pretendardBold = "Pretendard-Bold"
}

extension Font {
    static func customFont(_ font: FontName, size: CGFloat) -> Font {
        custom(font.rawValue, size: size)
    }
}
