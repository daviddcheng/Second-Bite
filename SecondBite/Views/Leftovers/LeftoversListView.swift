//
//  LeftoversListView.swift
//  SecondBite
//
//  Created by David Cheng on 11/30/25.
//

import SwiftUI

struct LeftoversListView: View {
    @EnvironmentObject var appViewModel: AppViewModel
    
    var body: some View {
        NavigationStack {
            List(appViewModel.diningHalls) { hall in
                VStack(alignment: .leading, spacing: 4) {
                    Text(hall.name)
                        .font(.headline)
                    
                    Text("\(hall.leftovers.count) leftover items")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
            .navigationTitle("Leftovers")
        }
    }
}

#Preview {
    LeftoversListView()
        .environmentObject(AppViewModel())
}
