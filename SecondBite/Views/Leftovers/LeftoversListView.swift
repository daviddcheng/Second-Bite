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
            ZStack(alignment: .top) {
                // Background
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        header
                        balanceCard
                        sectionHeader(title: "Top picks near you")
                        hallCards
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 12)
                    .padding(.bottom, 32)
                }
            }
            .navigationBarHidden(true)
        }
    }
    
    // MARK: - Subviews
    
    private var header: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                Image(systemName: "location.fill")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(Color.green.opacity(0.8))
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("Current location")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text("University City, Philadelphia")
                        .font(.subheadline.weight(.semibold))
                }
                
                Spacer()
                
                Button(action: {}) {
                    Image(systemName: "chevron.down")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.secondary)
                }
                .buttonStyle(.plain)
            }
            
            Text("Discover")
                .font(.largeTitle.bold())
        }
        .padding(.top, 8)
    }
    
    private var balanceCard: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Dining balance")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text("$\(Int(appViewModel.diningBalance))")
                    .font(.title2.bold())
                Text("Each surprise bag is just $10")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            Image(systemName: "takeoutbag.and.cup.and.straw.fill")
                .font(.system(size: 32))
                .foregroundStyle(Color.white)
                .padding(12)
                .background(
                    LinearGradient(
                        colors: [Color.green.opacity(0.9), Color.teal],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.08), radius: 16, x: 0, y: 8)
        )
    }
    
    private func sectionHeader(title: String) -> some View {
        HStack {
            Text(title)
                .font(.headline)
            Spacer()
            Button("See all") {}
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(Color.green.opacity(0.9))
        }
    }
    
    private var hallCards: some View {
        VStack(spacing: 16) {
            ForEach(appViewModel.diningHalls) { hall in
                NavigationLink {
                    DiningHallDetailView(hall: hall)
                } label: {
                    hallCard(for: hall)
                }
                .buttonStyle(.plain)
            }
        }
    }
    
    private func hallCard(for hall: DiningHall) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            ZStack(alignment: .bottomLeading) {
                // Dining hall image
                Image(hall.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 160)
                    .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                    .overlay(
                        // Dark gradient overlay for text readability
                        LinearGradient(
                            colors: [
                                Color.clear,
                                Color.black.opacity(0.6)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                    )
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(hall.name)
                        .font(.headline)
                        .foregroundStyle(.white)
                        .shadow(radius: 4)
                    
                    HStack(spacing: 4) {
                        Image(systemName: "clock")
                            .font(.caption)
                        Text("Pick up tonight • 7:45 PM – 8:30 PM")
                            .font(.caption)
                    }
                    .foregroundStyle(.white.opacity(0.9))
                    .shadow(radius: 4)
                }
                .padding(12)
            }
            
            HStack(alignment: .firstTextBaseline) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Surprise Bag")
                        .font(.subheadline.weight(.semibold))
                    
                    HStack(spacing: 4) {
                        Image(systemName: "location")
                            .font(.caption)
                        Text("On campus • ~0.3 mi")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text("$15.00")
                        .font(.caption)
                        .strikethrough()
                        .foregroundStyle(.secondary)
                    Text("$10.00")
                        .font(.headline.weight(.bold))
                        .foregroundStyle(Color.green.opacity(0.9))
                    Text("5+ left")
                        .font(.caption2.weight(.semibold))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(
                            Capsule()
                                .fill(Color.green.opacity(0.12))
                        )
                }
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.06), radius: 10, x: 0, y: 6)
        )
    }
}

#Preview {
    LeftoversListView()
        .environmentObject(AppViewModel())
}
