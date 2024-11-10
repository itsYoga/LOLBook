//
//  ChampionModel.swift
//  LOLBook
//
//  Created by Jesse Liang on 2024/11/10.
//

import Foundation

// 定義版本型別，存儲版本字符串的陣列
typealias Versions = [String]

// MARK: - Champion

// Champion 結構，對應於英雄的資料，符合 Codable 和 Hashable 協定，便於序列化和哈希運算
struct Champion: Codable, Hashable {
    var type: TypeEnum   // 英雄類型（例如 champion 或 spell）
    var format: String   // 資料格式
    var data: [String: Datum]  // 英雄的具體資料，使用字典存儲英雄資料，以英雄的 ID 為鍵
}

// MARK: - Datum

// Datum 結構，包含每個英雄的具體資料，符合 Codable 和 Hashable 協定
struct Datum: Codable, Hashable {
    var id, key, name, title: String   // 英雄的 ID、鍵、名稱、標題
    var lore: String   // 英雄的背景故事
    var blurb: String  // 簡短介紹
    var allytips: [String]   // 同隊隊友提示
    var enemytips: [String]  // 敵方提示
    var info: Info     // 英雄的屬性資訊（攻擊、防禦、魔法、難度）
    var image: ChampionImage   // 英雄的圖片資料
    var tags: [String] // 英雄的標籤（例如戰士、法師等）
    var spells: [Spell]  // 英雄的技能列表
    var passive: Passive  // 英雄的被動技能
    var partype: String   // 能量類型（例如法力、怒氣等）
    var stats: [String: Double]  // 英雄的屬性數值（例如攻擊力、生命值等）
}

// MARK: - Spell

// Spell 結構，包含英雄的技能資料
struct Spell: Codable, Hashable {
    var id, name, spellDescription, tooltip: String   // 技能的 ID、名稱、描述和提示
    var maxrank: Int  // 技能的最大等級
    var cooldown: [Float]   // 技能的冷卻時間
    var cost: [Int]   // 技能的消耗（如法力消耗）
    var costBurn: String  // 技能消耗的文本格式
    var costType, maxammo: String  // 消耗類型（如法力、能量）和最大彈藥數量
    var image: ChampionImage   // 技能的圖片資料
    var resource: String?  // 資源類型（例如法力、能量等）

    // 定義 CodingKeys，將 JSON 鍵名稱映射到 Swift 屬性
    enum CodingKeys: String, CodingKey {
        case id, name
        case spellDescription = "description"   // 將 JSON 中的 "description" 映射為 spellDescription
        case tooltip, maxrank, cooldown, cost, costBurn, costType, maxammo, image, resource
    }
}

// MARK: - Passive

// Passive 結構，包含英雄的被動技能資料
struct Passive: Codable, Hashable {
    var name: String   // 被動技能名稱
    var description: String   // 被動技能描述
    var image: ChampionImage   // 被動技能的圖片資料
}

// MARK: - ChampionImage

// ChampionImage 結構，描述圖像的資料，包括檔案名稱、位置等
struct ChampionImage: Codable, Hashable {
    var full: String  // 完整圖片檔案名稱
    var sprite: String  // 圖片所在的 sprite 檔案名稱
    var group: String  // 圖片組別
    var x, y, w, h: Int   // 圖片在 sprite 檔案中的位置（x, y）和尺寸（寬度 w 和高度 h）
}

// 定義 TypeEnum 類型，用來表示資料類型（例如 champion 或 spell）
enum TypeEnum: String, Codable, Hashable {
    case champion  // 英雄
    case spell     // 技能
}

// MARK: - Info

// Info 結構，包含英雄的屬性資訊（攻擊、防禦、魔法、難度）
struct Info: Codable, Hashable {
    var attack, defense, magic, difficulty: Int   // 攻擊力、防禦力、魔法能力和難度
}
