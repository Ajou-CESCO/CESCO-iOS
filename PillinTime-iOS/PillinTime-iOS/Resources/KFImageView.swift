//
//  KFImageView.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 5/12/24.
//

import SwiftUI
import Kingfisher

struct KFImageView: View {
    var urlString: String
    var emptyPlaceholder: String = "img_placeholder"
    var loadingPlaceholder: String = "img_loading"
    

    var body: some View {
        if urlString.isEmpty {
            Image(emptyPlaceholder)
        } else {
            KFImage(URL(string: urlString))
                .placeholder {
                    Image(loadingPlaceholder)
                }
                .onSuccess { r in
                    print("이미지 로딩 성공: \(r.source.url?.absoluteString ?? "")")
                }
                .onFailure { e in
                    print("이미지 로딩 실패: \(e.localizedDescription)")
                }
                .resizable()
                .aspectRatio(contentMode: .fill) 
        }
    }
}
