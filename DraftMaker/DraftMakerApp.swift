import SwiftUI

@main
struct DraftMakerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

// カスタムカラー定義
extension Color {
    static let cuteBackground = Color(red: 1.0, green: 0.96, blue: 0.96) // 薄いピンクベージュ
    static let cuteCard = Color.white
    static let cutePrimary = Color(red: 1.0, green: 0.6, blue: 0.6) // コーラルピンク
    static let cuteText = Color(red: 0.3, green: 0.25, blue: 0.25) // こげ茶色
    static let cuteShadow = Color.black.opacity(0.05)
}
