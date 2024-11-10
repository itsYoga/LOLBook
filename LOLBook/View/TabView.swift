//
//  Untitled.swift
//  LOLBook
//
//  Created by Jesse Liang on 2024/11/10.
//

import SwiftUI
import WebKit

// WebView 用來顯示 YouTube 影片
struct WebView: UIViewRepresentable {
    let url: URL  // 影片的 URL
    
    // 創建 WKWebView 實例
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        let request = URLRequest(url: url) // 建立 URL 請求
        webView.load(request) // 載入請求
        return webView
    }
    
    // 更新 UIView，這裡可以放置需要更新的邏輯
    func updateUIView(_ uiView: WKWebView, context: Context) {
        // 根據需要進行更新
    }
}

// MusicVideoView 顯示 YouTube 影片的視圖
struct MusicVideoView: View {
    let videoURL: URL  // 影片 URL
    
    var body: some View {
        WebView(url: videoURL) // 使用 WebView 顯示影片
            .edgesIgnoringSafeArea(.all) // 讓影片顯示為全螢幕
    }
}

// 主頁面，包含 Champions, Runes, 和 Music 分頁
struct Tab: View {
    // 設定 TabBar 的外觀
    init() {
        UITabBar.appearance().isTranslucent = true // 設定為半透明
        UITabBar.appearance().barTintColor = UIColor(named: "cardColor") // 設定 TabBar 背景顏色
    }

    @State private var selection = "Champions" // 記錄當前選中的分頁，默認為 "Champions"
    @AppStorage("isDarkMode") private var isDarkMode = false // 記錄使用者是否啟用深色模式
    @StateObject var champFetcher = ChampionFetcher() // 管理並抓取英雄資料

    var body: some View {
        TabView(selection: $selection) { // 使用 TabView 來顯示分頁
            // Champions 分頁
            ChampionsView(champFetcher: champFetcher)
                .tabItem {
                    SwiftUI.Image("champIcon") // 設定圖示
                        .renderingMode(.template) // 使用 template 渲染模式
                    Text("Champions") // 分頁文字
                }
                .tag("Champions") // 設定這個分頁的標籤
                .transition(.move(edge: .trailing)) // 當選擇分頁時，使用從右邊移動的動畫

            // Runes 分頁
            RunesView()
                .tabItem {
                    SwiftUI.Image("runeIcon") // 設定圖示
                        .renderingMode(.template) // 使用 template 渲染模式
                    Text("Runes") // 分頁文字
                }
                .tag("Runes") // 設定這個分頁的標籤
                .transition(.move(edge: .leading)) // 當選擇分頁時，使用從左邊移動的動畫

            // Music 分頁，顯示歌曲清單
            MusicView() // 音樂清單視圖
                .tabItem {
                    SwiftUI.Image(systemName: "music.note") // 使用 SF Symbol 圖標
                    Text("Music") // 分頁文字
                }
                .tag("Music") // 設定這個分頁的標籤
                .transition(.move(edge: .bottom)) // 當選擇分頁時，使用從底部移動的動畫
        }
        .preferredColorScheme(isDarkMode ? .dark : .light) // 根據使用者選擇的深色模式顯示相應的界面
        .animation(.easeInOut(duration: 0.5), value: selection) // 設定選擇分頁時的動畫效果
    }
}

struct Tab_Previews: PreviewProvider {
    static var previews: some View {
        Tab() // 預覽 Tab 視圖
    }
}
