//
//  CacheAsyncImage.swift
//  LOLBook
//
//  Created by Jesse Liang on 2024/11/10.
//

import Foundation
import SwiftUI

// CacheAsyncImage 組件，提供異步圖片載入與緩存功能
struct CacheAsyncImage<Content>: View where Content: View {
    
    // MARK: - Properties

    private let url: URL // 圖片的 URL
    private let scale: CGFloat // 圖片縮放比例，默認為 1.0
    private let transcation: Transaction // 圖片載入動畫的過渡效果
    private let content: (AsyncImagePhase) -> Content // 當前圖片載入階段的處理方式

    // 初始化方法，設定圖片 URL、縮放比例、過渡效果，以及圖片載入階段的處理內容
    init(
        url: URL,
        scale: CGFloat = 1.0,
        transcation: Transaction = Transaction(),
        @ViewBuilder content: @escaping (AsyncImagePhase) -> Content
    ) {
        self.url = url
        self.scale = scale
        self.transcation = transcation
        self.content = content
    }

    // MARK: - Body

    var body: some View {
        // 檢查圖片是否已存在緩存中
        if let cached = ImageCache[url] {
//            let _ = print("cached \(url.absoluteString)")
            content(.success(cached)) // 如果存在緩存中，直接顯示圖片
        } else {
//            let _ = print("request \(url.absoluteString)")
            AsyncImage(
                url: url,
                scale: scale,
                transaction: transcation
            ) { phase in
                cacheAndRender(phase: phase) // 否則使用 AsyncImage 載入圖片，並進行緩存
            }
        }
    }

    // 將圖片載入階段的結果緩存，並返回處理結果
    func cacheAndRender(phase: AsyncImagePhase) -> some View {
        if case let .success(image) = phase {
            ImageCache[url] = image // 如果載入成功，將圖片存入緩存
        }
        return content(phase) // 回傳處理後的圖片
    }
}

// MARK: - ImageCache

// ImageCache 用來緩存已載入的圖片，避免重複下載
private enum ImageCache {
    static var cache: [URL: SwiftUI.Image] = [:] // 使用字典將圖片 URL 與圖片對應

    // 子腳本，用來取得或設置圖片
    static subscript(url: URL) -> SwiftUI.Image? {
        get {
            ImageCache.cache[url] // 取得緩存中的圖片
        }
        set {
            ImageCache.cache[url] = newValue // 設置新的圖片進緩存
        }
    }
}
