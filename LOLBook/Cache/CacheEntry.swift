//
//  Untitled.swift
//  LOLBook
//
//  Created by Jesse Liang on 2024/11/10.
//


import Foundation

// 定義一個泛型類別 CacheEntry，用於緩存的項目管理
final class CacheEntry<V> {
    
    // MARK: - Properties

    let key: String // 緩存項的唯一標識
    let value: V // 緩存的值，為泛型類型
    let expiredTimestamp: Date // 緩存的過期時間

    // 初始化方法，用來設置緩存項的 key、value 和過期時間
    init(key: String, value: V, expiredTimestamp: Date) {
        self.key = key
        self.value = value
        self.expiredTimestamp = expiredTimestamp
    }

    // 判斷緩存是否已過期
    func isCacheExpired(after date: Date = .now) -> Bool {
        date > expiredTimestamp // 當前時間是否超過過期時間
    }
}
