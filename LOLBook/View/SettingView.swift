import SwiftUI

struct SettingsView: View {
    // 使用 @AppStorage 來儲存暗黑模式與語言設置的狀態，這些狀態會在應用程式間保持
    @AppStorage("isDarkMode") private var isDarkMode = false  // 暗黑模式開關
    @AppStorage("selectedLanguage") private var selectedLanguage: String = "en"  // 預設語言為英文
    
    // 控制動畫狀態的變數
    @State private var toggleAnimation = false // 用於控制切換動畫
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    // 暗黑模式開關，並附帶動畫效果
                    Toggle(isOn: $isDarkMode) {
                        HStack {
                            ZStack {
                                // 切換按鈕的背景顏色會根據暗黑模式的開關變化
                                Rectangle()
                                    .frame(width: 36, height: 36)
                                    .cornerRadius(10)
                                    .foregroundColor(isDarkMode ? .purple : .blue)
                                    .animation(.easeInOut(duration: 0.3), value: isDarkMode)  // 切換顏色時加上平滑過渡動畫
                                // 顯示太陽圖示，顏色設為白色
                                Image(systemName: "sun.max")
                                    .foregroundColor(.white)
                            }
                            // "Dark Mode" 標籤，顏色會根據暗黑模式切換
                            Text("Dark Mode")
                                .fontWeight(.semibold)
                                .foregroundColor(isDarkMode ? .white : .black)
                        }
                    }
                    .animation(.spring(), value: toggleAnimation)  // 透過 spring 動畫效果來讓切換更平滑
                    
                    // 語言選擇設置
                    HStack {
                        ZStack {
                            // 語言選擇區塊的背景顏色
                            Rectangle()
                                .frame(width: 36, height: 36)
                                .cornerRadius(10)
                                .foregroundColor(.red)
                            // 顯示國旗圖示
                            Image(systemName: "flag")
                                .foregroundColor(.white)
                        }
                        // "Language" 標籤，顏色根據暗黑模式切換
                        Text("Language")
                            .fontWeight(.semibold)
                            .foregroundColor(isDarkMode ? .white : .black)
                        Spacer()
                        // 語言選擇器，使用 SegmentedPickerStyle 顯示兩個語言選項
                        Picker("", selection: $selectedLanguage) {
                            Text("English").tag("en")  // 英文
                            Text("中文").tag("zh")    // 中文
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .transition(.scale)  // 轉換時使用縮放動畫
                    }
                    .padding(.vertical)  // 語言選擇區塊上下邊距
                }
                .listStyle(.plain)  // 設定列表的樣式
                .background(isDarkMode ? Color.black : Color.white)  // 根據暗黑模式設定背景顏色
                
                Spacer()
            }
            .navigationTitle("Settings")  // 設定頁面標題
            .padding()  // 頁面內邊距
            .background(isDarkMode ? Color.black : Color.white)  // 設定頁面背景顏色
            .onChange(of: selectedLanguage) { _ in
                // 當語言選擇變動時，觸發動畫效果
                withAnimation {
                    toggleAnimation.toggle()
                }
            }
        }
        // 設定應用程式顯示模式，根據暗黑模式切換
        .preferredColorScheme(isDarkMode ? .dark : .light)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()  // 設定頁面預覽
    }
}
