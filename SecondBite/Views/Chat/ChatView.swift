//
//  ChatView.swift
//  SecondBite
//
//  Created by David Cheng on 11/30/25.
//

import SwiftUI

struct ChatView: View {
    var body: some View {
        NavigationStack {
            Text("AI Chat will go here")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(.systemGroupedBackground))
                .navigationTitle("AI Chat")
        }
    }
}

#Preview {
    ChatView()
}
