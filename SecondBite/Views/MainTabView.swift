//
//  MainTabView.swift
//  SecondBite
//
//  Created by David Cheng on 11/30/25.
//

import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var appViewModel: AppViewModel
    
    var body: some View {
        TabView {
            MapScreen()
                .tabItem {
                    Label("Map", systemImage: "map")
                }
            
            LeftoversListView()
                .tabItem {
                    Label("Leftovers", systemImage: "takeoutbag.and.cup.and.straw")
                }
            
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.crop.circle")
                }
            
            ChatView()
                .tabItem {
                    Label("AI Chat", systemImage: "message")
                }
        }
    }
}

#Preview {
    MainTabView()
        .environmentObject(AppViewModel())
}
