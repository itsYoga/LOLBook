//
//  CacheImplementation.swift
//  LOLBook
//
//  Created by Jesse Liang on 2024/11/10.
//


import Foundation

// InMemoryCache 類別負責在記憶體中管理緩存的項目，並提供過期機制
class InMemoryCache<V> {
    
    // 使用 NSCache 來管理緩存項目，NSCache 自動處理記憶體的釋放
    fileprivate let cache: NSCache<NSString, CacheEntry<V>> = .init()
    
    let expirationInterval: TimeInterval // 緩存的過期時間間隔

    // 初始化方法，指定緩存的過期時間
    init(expirationInterval: TimeInterval) {
        self.expirationInterval = expirationInterval
    }

    // MARK: - 緩存操作方法

    // 刪除指定 key 的緩存項目
    func removeValue(forKey key: String) {
        cache.removeObject(forKey: key as NSString)
    }

    // 清空所有緩存項目
    func removeAllValues() {
        cache.removeAllObjects()
    }

    // 設定緩存的值，並計算過期時間
    func setValue(_ value: V?, forKey key: String) {
        if let value = value {
            // 計算緩存的過期時間
            let expiredTimestamp = Date().addingTimeInterval(expirationInterval)
            // 建立新的緩存項目，並將其加入緩存
            let cacheEntry = CacheEntry(key: key, value: value, expiredTimestamp: expiredTimestamp)
            cache.setObject(cacheEntry, forKey: key as NSString)
        } else {
            // 若傳入的值為 nil，則刪除此 key 的緩存
            removeValue(forKey: key)
        }
    }

    // 取得指定 key 的緩存值
    func value(forKey key: String) -> V? {
        // 嘗試從緩存中取得項目
        guard let entry = cache.object(forKey: key as NSString) else {
            return nil // 若無此項目則回傳 nil
        }

        // 檢查緩存是否過期
        guard !entry.isCacheExpired(after: Date()) else {
            // 若已過期則刪除此緩存項目，並回傳 nil
            removeValue(forKey: key)
            return nil
        }

        return entry.value // 若未過期，回傳緩存值
    }
}
