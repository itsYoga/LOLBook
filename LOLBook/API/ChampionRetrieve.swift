//
//  ChampionRetrieve.swift
//  LOLBook
//
//  Created by Jesse Liang on 2024/11/10.
//

// ChampionRetrieve.swift

import Foundation
import SwiftUI

// ChampionFetcher 類別負責從 API 獲取和處理《英雄聯盟》英雄的資料
@MainActor
class ChampionFetcher: ObservableObject {
    // 用來儲存英雄列表
    @Published var championsList: [Datum] = []
    // 用來顯示是否正在載入英雄資料
    @Published var isChampLoading: Bool = false
    // 用來儲存錯誤訊息
    @Published var errorMessage: String?
    // 儲存當前的遊戲版本
    @AppStorage("version") private var version: String = ""

    // 用來搜尋和篩選英雄的變數
    @Published var searchText: String = ""
    @Published var selectedSort: Int = 0
    
    // 計算屬性：根據搜尋文字和排序條件來篩選英雄列表
    var filteredList: [Datum] {
        if selectedSort == 1 {
            if !searchText.isEmpty {
                return championsList.filter { "\($0)".contains(searchText.capitalized) }
            } else {
                return championsList.sorted(by: { $0.name > $1.name })
            }
        } else {
            if !searchText.isEmpty {
                return championsList.filter { "\($0)".contains(searchText.capitalized) }
            } else {
                return championsList.sorted(by: { $0.name < $1.name })
            }
        }
    }

    // 設定快取，快取時間為 10 分鐘
    private let cache = InMemoryCache<[Datum]>(expirationInterval: 10 * 60)

    // 初始化時獲取版本號
    init() {
        getVersion()
    }

    // 獲取當前的遊戲版本
    func getVersion() {
        let manager = ApiManager()
        let url = URL(string: "\(ddragon)/api/versions.json")
        manager.fetchAPI(Versions.self, url: url, completion: { [unowned self] result in
            DispatchQueue.main.async {
                // 當獲取版本成功後，設定版本號
                switch result {
                case let .failure(error):
                    self.errorMessage = error.userDescription
                    print(error.description)
                case let .success(versions):
                    self.version = versions.first ?? ""
                }
            }
        })
    }

    // 載入英雄資料，先檢查是否有快取
    func loadChampData() {
        isChampLoading = true
        errorMessage = nil

        // 如果有快取的英雄資料，就直接使用快取
        if let championsList = cache.value(forKey: "champs") {
            self.championsList = championsList
            isChampLoading = false
            print("cache HIT")
        } else {
            // 如果沒有快取，就從 API 獲取資料
            let manager = ApiManager()
            let url = URL(string: "\(ddragon)/cdn/\(String(describing: version))/data/\(ddlanguage)/championFull.json")
            manager.fetchAPI(Champion.self, url: url, completion: { [unowned self] result in
                DispatchQueue.main.async {
                    self.isChampLoading = false
                    // 根據 API 載入結果來更新資料
                    switch result {
                    case let .failure(error):
                        self.errorMessage = error.userDescription
                        print(error.description)
                    case let .success(champion):
                        // 更新英雄列表並快取資料
                        self.championsList = Array(champion.data.values)
                        self.cache.setValue(self.championsList, forKey: "champs")
                        print("cache set")
                    }
                }
            })
        }
    }
}
