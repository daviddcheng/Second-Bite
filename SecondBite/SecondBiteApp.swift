//
//  SecondBiteApp.swift
//  SecondBite
//
//  Created by David Cheng on 11/30/25.
//

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
