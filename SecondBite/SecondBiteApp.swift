import SwiftUI

@main
struct SecondBiteApp: App {
    @StateObject private var appViewModel = AppViewModel()
    
    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environmentObject(appViewModel)
        }
    }
}
