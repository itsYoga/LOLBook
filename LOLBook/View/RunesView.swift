import SwiftUI

// 每個主要符文的描述文字，用於顯示於列表中
let keystoneDescription = [
    LocalizedStringKey("Hunt and eliminate prey.\nBurst damage and target access"),
    LocalizedStringKey("Outwit mere mortals.\nCreative tools and rule bending"),
    LocalizedStringKey("Become a legend.\nImproved attack and sustained damage"),
    LocalizedStringKey("Live forever.\nDurability and crowd control"),
    LocalizedStringKey("Unleash destruction.\nEmpowered abilities and resource manipulation"),
]

// 對應的符文圖片名稱
let imageName = [
    "Domination",
    "Inspiration",
    "Precision",
    "Resolve",
    "Sorcery",
]

struct RunesView: View {
    @StateObject var runeFetcher = RuneFetcher() // 使用 StateObject 管理符文資料的來源

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 15) {
                    // 動態生成符文清單的每一行
                    ForEach(runeFetcher.runesList.indices, id: \.self) { index in
                        RuneListRow(index: index, runeFetcher: runeFetcher)
                    }
                    Spacer()
                }
                .navigationTitle("Runes") // 設置頁面標題
                .onAppear {
                    runeFetcher.loadRunesData() // 當頁面顯示時載入符文資料
                }
                .background(Color(UIColor.systemBackground)) // 背景顏色支援黑暗模式
            }
        }
        .preferredColorScheme(.dark) // 預覽時強制使用黑暗模式（可選）
    }
}

struct RuneListRow: View {
    var index: Range<Array<MainRune>.Index>.Element
    @ObservedObject var runeFetcher: RuneFetcher

    @State private var appear = false // Animation state

    var body: some View {
        NavigationLink(destination: RunesDetail(mainRune: runeFetcher.runesList[index])) {
            ZStack {
                Rectangle()
                    .cornerRadius(30)
                    .foregroundColor(Color("cardColor")) // 自定義顏色，支持黑暗模式

                HStack {
                    ZStack {
                        Rectangle()
                            .cornerRadius(20)
                            .foregroundColor(Color("innerCard")) // 自定義顏色，支持黑暗模式
                        SwiftUI.Image(imageName[index])
                            .resizable()
                            .frame(width: 35, height: 35)
                    }
                    .frame(width: 70, height: 70)

                    VStack(alignment: .leading) {
                        Text(runeFetcher.runesList[index].name)
                            .foregroundColor(.primary) // 自動適應黑暗模式
                            .font(.system(size: 20))
                            .fontWeight(.bold)
                        Text(keystoneDescription[index])
                            .foregroundColor(.secondary) // 自動適應黑暗模式
                            .font(.system(size: 15))
                            .multilineTextAlignment(.leading)
                    }
                    .frame(width: 230, height: 80, alignment: .leading)

                    Spacer()

                    Text(">")
                        .foregroundColor(.secondary) // 自動適應黑暗模式
                    Spacer()
                }
                .padding(.leading, 20)
            }
            .frame(width: 373, height: 108)
            .opacity(appear ? 1 : 0) // Fade-in animation
            .onAppear {
                withAnimation(.easeIn(duration: 0.5)) {
                    appear = true
                }
            }
        }
    }
}

// MARK: - PREVIEW

// 預覽 RunesView，方便檢視設計和功能
struct RunesView_Previews: PreviewProvider {
    static var previews: some View {
        RunesView()
            .preferredColorScheme(.dark) // 強制使用黑暗模式顯示
    }
}
