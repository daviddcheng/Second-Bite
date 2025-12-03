import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var appViewModel: AppViewModel
    
    var body: some View {
        TabView {
            LeftoversListView()
                .tabItem {
                    Label("Discover", systemImage: "safari")
                }
            
            MapView()
                .tabItem {
                    Label("Map", systemImage: "map")
                }
            
            ChatView()
                .tabItem {
                    Label("AI Chat", systemImage: "message")
                }
            
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.crop.circle")
                }
            
        }
    }
}

#Preview {
    MainTabView()
        .environmentObject(AppViewModel())
}
