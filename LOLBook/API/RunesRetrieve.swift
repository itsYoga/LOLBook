//
//  RunesRetrieve.swift
//  LOLBook
//
//  Created by Jesse Liang on 2024/11/10.
//

import Foundation
import SwiftUI

// RuneFetcher 類別負責從 API 獲取和處理《英雄聯盟》中的符文資料
class RuneFetcher: ObservableObject {
    // 用來儲存符文列表
    @Published var runesList: [MainRune] = []
    // 用來顯示是否正在載入符文資料
    @Published var isRunesLoading: Bool = false
    // 用來儲存錯誤訊息
    @Published var errorMessage: String?

    // 載入符文資料的函式
    func loadRunesData() {
        // 設定正在載入
        isRunesLoading = true
        errorMessage = nil

        // 使用 ApiManager 來發送 API 請求
        let manager = ApiManager()
        let url = URL(string: "\(ddragon)/cdn/12.12.1/data/\(ddlanguage)/runesReforged.json")
        
        // 發送請求並處理回應
        manager.fetchAPI([MainRune].self, url: url, completion: { [unowned self] result in
            DispatchQueue.main.async {
                self.isRunesLoading = false // 載入結束
                // 根據 API 載入結果更新符文列表或顯示錯誤訊息
                switch result {
                case let .failure(error):
                    self.errorMessage = error.userDescription // 設定錯誤訊息
                    print(error.description) // 輸出錯誤描述
                case let .success(rune):
                    self.runesList = rune // 更新符文列表
                }
            }
        })
    }
}
