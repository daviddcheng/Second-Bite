//
//  MapView.swift
//  SecondBite
//
//  Created by David Cheng on 11/30/25.
//

import SwiftUI

struct MapView: View {
    @EnvironmentObject var appViewModel: AppViewModel
    
    var body: some View {
        NavigationStack {
            List(appViewModel.diningHalls) { hall in
                VStack(alignment: .leading) {
                    Text(hall.name)
                        .font(.headline)
                    Text(hall.description)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
            .navigationTitle("Dining Halls Map")
        }
    }
}

#Preview {
    MapView()
        .environmentObject(AppViewModel())
}
