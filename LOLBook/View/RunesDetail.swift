//
//  RunesDetail.swift
//  LOLBook
//
//  Created by Jesse Liang on 2024/11/10.
//


import SwiftUI

struct RunesDetail: View {
    var mainRune: MainRune // 接收符文的主要類型作為詳細頁面的資料來源

    var body: some View {
        ScrollView(showsIndicators: false) { // 主內容為可滾動視圖，不顯示滾動條
            VStack(alignment: .leading) {
                // 顯示主要符文的標題
                Text("Keystones")
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                    .font(.system(size: 20))
                
                ScrollView(.horizontal, showsIndicators: false) { // 水平滾動顯示主要符文
                    HStack(spacing: 20) {
                        ForEach(mainRune.slots.first!.runes, id: \.self) { runes in
                            VStack(alignment: .leading) {
                                ZStack {
                                    // 符文圖標的背景
                                    Rectangle()
                                        .cornerRadius(20)
                                        .foregroundColor(Color("cardColor"))
                                    
                                    // 加載並顯示符文圖標圖片
                                    AsyncImage(url: URL(string: "https://ddragon.leagueoflegends.com/cdn/img/" + (runes.icon))) { phase in
                                        if let image = phase.image {
                                            image.resizable()
                                                .scaledToFit()
                                                .frame(width: 160, height: 160)
                                        } else if phase.error != nil {
                                            Color.red // 當圖片加載失敗時顯示紅色方框
                                                .frame(width: 80, height: 80)
                                        } else {
                                            ProgressView() // 加載過程中顯示進度視圖
                                                .frame(width: 80, height: 80)
                                        }
                                    }
                                }
                                .frame(width: 320, height: 170, alignment: .center)
                                
                                // 符文名稱和描述
                                Text(runes.name)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.primary)
                                    .font(.system(size: 18))
                                Text(runes.longDesc.replacingOccurrences(of: "\\s?\\<[^>]*\\>", with: " ", options: .regularExpression))
                                    .foregroundColor(.secondary)
                                    .font(.system(size: 15))
                                    .frame(alignment: .topLeading)
                                Spacer()
                            }
                            .frame(width: 320, alignment: .leading)
                        }
                    }
                    Spacer()
                }
                Spacer()
                
                // 顯示次要符文的標題
                Text("Secondary")
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                    .font(.system(size: 20))

                LazyVStack(alignment: .leading, spacing: 20) {
                    ForEach(mainRune.slots.dropFirst(), id: \.self) { slots in // 略過第一個符文槽
                        ForEach(slots.runes, id: \.self) { rune in
                            HStack {
                                // 加載並顯示次要符文圖標圖片
                                CacheAsyncImage(url: URL(string: "https://ddragon.leagueoflegends.com/cdn/img/" + (rune.icon))!) { phase in
                                    if let image = phase.image {
                                        image.resizable()
                                            .scaledToFit()
                                            .frame(width: 64, height: 64)
                                    } else if phase.error != nil {
                                        Color.red
                                            .frame(width: 64, height: 64)
                                    } else {
                                        ProgressView()
                                            .frame(width: 64, height: 64)
                                    }
                                }
                                VStack(alignment: .leading) {
                                    // 次要符文名稱和描述
                                    Text(rune.name)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.primary)
                                        .font(.system(size: 18))
                                    Text(rune.longDesc.replacingOccurrences(of: "\\s?\\<[^>]*\\>", with: " ", options: .regularExpression))
                                        .foregroundColor(.secondary)
                                        .font(.system(size: 15))
                                }
                            }
                            Divider() // 每個符文項目之間的分隔線
                        }
                    }
                }
            }
            Spacer()
        }
        .navigationTitle(mainRune.name) // 將主要符文名稱作為頁面標題
        .padding() // 頁面四周增加填充
    }
}

// struct RunesDetail_Previews: PreviewProvider {
//    static var previews: some View {
//        RunesDetail(mainRune: )
//    }
// }
