//
//  RunesModel.swift
//  LOLBook
//
//  Created by Jesse Liang on 2024/11/10.
//


import Foundation

// MARK: - MainRune

// MainRune 結構，表示主要符文的資料，符合 Codable 和 Hashable 協定
struct MainRune: Codable, Hashable {
    var id: Int           // 符文的唯一識別碼
    var key, icon, name: String  // 符文的鍵、圖示和名稱
    var slots: [Slot]     // 符文的槽位，包含各種符文（Slots 裡面包含的 Rune）
}

// MARK: - Slot

// Slot 結構，表示每個符文槽位，包含多個符文（Runes）
struct Slot: Codable, Hashable {
    var runes: [Rune]     // 此槽位中的符文列表
}

// MARK: - Rune

// Rune 結構，表示具體的符文資料，符合 Codable 和 Hashable 協定
struct Rune: Codable, Hashable {
    var id: Int           // 符文的唯一識別碼
    var key: String       // 符文的鍵
    var icon: String      // 符文的圖示名稱（通常是圖像檔案名稱）
    var name: String      // 符文的名稱
    var shortDesc: String // 符文的簡短描述
    var longDesc: String  // 符文的詳細描述
}
