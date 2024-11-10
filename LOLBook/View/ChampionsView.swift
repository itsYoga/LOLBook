//
//  ChampionsView.swift
//  LOLBook
//
//  Created by Jesse Liang on 2024/11/10.
//


import SwiftUI

// 主視圖，展示英雄列表

struct ChampionsView: View {
    @ObservedObject var champFetcher: ChampionFetcher  // 管理資料的類別

    var sortTypes = ["A-Z", "Z-A"]  // 排序類型
    @State private var searchText = ""  // 搜尋框文字
    @State private var selectedSort = 0 // 目前選取的排序方式

    var body: some View {
        NavigationView {
            VStack {
                if champFetcher.isChampLoading {
                    Text("Loading...")  // 資料加載中文字樣
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                        .shadow(radius: 5)  // 增加陰影效果
                } else if champFetcher.errorMessage != nil {
                    Text(champFetcher.errorMessage ?? "An error occurred")  // 顯示錯誤訊息
                } else {
                    // 顯示英雄列表
                    List(champFetcher.filteredList, id: \.self) { champ in
                        NavigationLink(destination: ChampDetailView(champ: champ)) {
                            ChampListRow(champ: champ)  // 每個英雄的列表項
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .searchable(text: $champFetcher.searchText)  // 搜尋功能
            .disableAutocorrection(true)  // 停用自動更正
            .navigationTitle("Champions")  // 導覽標題
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Picker(selection: $champFetcher.selectedSort, label: Text("Sort")) {
                        ForEach(0 ..< sortTypes.count, id: \.self) {
                            Text(self.sortTypes[$0])  // 排序選單
                        }
                    }
                }
            }
        }
        .onAppear { champFetcher.loadChampData() }  // 載入資料
    }
}

// 英雄列表的每一行
struct ChampListRow: View {
    var champ: Datum

    var body: some View {
        HStack {
            // 顯示英雄圖片，支援緩存
            CacheAsyncImage(url: URL(string: "\(ddragon)/cdn/12.1.1/img/champion/" + (champ.id) + ".png")!) { phase in
                if let image = phase.image {
                    image.resizable()
                        .clipped()
                        .frame(width: 80, height: 80)
                        .shadow(radius: 5)  // 增加陰影效果
                } else if phase.error != nil {
                    Text("?")  // 若圖片載入失敗顯示問號
                        .font(.system(size: 40))
                        .fontWeight(.bold)
                        .frame(width: 80, height: 80)
                        .background(Color.red.opacity(0.6))
                } else {
                    Text("Loading...")  // 資料加載中文字樣
                        .frame(width: 80, height: 80)
                        .background(Color.gray.opacity(0.3))
                        .cornerRadius(10)
                        .shadow(radius: 5)  // 增加陰影效果
                }
            }

            // 顯示英雄的名稱與標題
            VStack(alignment: .leading) {
                Text(champ.name)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                Text(champ.title)
                    .fontWeight(.regular)
                    .foregroundColor(.secondary)
            }
        }
    }
}

// 預覽設定
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ChampionsView(champFetcher: ChampionFetcher())
    }
}
