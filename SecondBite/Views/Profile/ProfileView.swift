//
//  ProfileView.swift
//  SecondBite
//
//  Created by David Cheng on 11/30/25.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var appViewModel: AppViewModel
    @StateObject private var viewModel = ProfileViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Profile Header Card
                    ProfileHeaderCard(preferences: viewModel.preferences)
                    
                    // Balance Card
                    BalanceCard(
                        balance: viewModel.preferences.balance,
                        onAddFunds: {
                            viewModel.addFunds(amount: 25.00)
                        }
                    )
                    
                    // Dietary Preferences Card
                    DietaryPreferencesCard(preferences: viewModel.preferences)
                    
                    // Favorite Dining Halls
                    FavoriteDiningHallsCard(
                        favorites: viewModel.preferences.favoriteDiningHalls,
                        allHalls: appViewModel.diningHalls,
                        onToggleFavorite: { hallName in
                            viewModel.toggleFavoriteDiningHall(hallName)
                        }
                    )
                    
                    // Settings Section
                    SettingsCard(
                        onEditPreferences: {
                            viewModel.showingPreferencesForm = true
                        },
                        onResetDefaults: {
                            viewModel.resetToDefaults()
                        }
                    )
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Profile")
            .onAppear {
                viewModel.reloadPreferences()
                // Sync preferences with AppViewModel
                appViewModel.userPreferences = viewModel.preferences
            }
            .onChange(of: viewModel.preferences) { _, newPrefs in
                // Keep AppViewModel in sync
                appViewModel.userPreferences = newPrefs
            }
            .sheet(isPresented: $viewModel.showingPreferencesForm) {
                PreferencesFormView(viewModel: viewModel)
            }
            .alert(item: $viewModel.purchaseAlert) { alert in
                Alert(
                    title: Text(alert.title),
                    message: Text(alert.message),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
}

// MARK: - Profile Header Card

struct ProfileHeaderCard: View {
    let preferences: UserPreferences
    
    var body: some View {
        VStack(spacing: 12) {
            // Avatar
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [.blue, .purple],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 80, height: 80)
                
                Text(initials)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
            
            VStack(spacing: 4) {
                Text(preferences.name)
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Text(preferences.email)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 24)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.05), radius: 8, y: 2)
    }
    
    private var initials: String {
        let components = preferences.name.split(separator: " ")
        let firstInitial = components.first?.prefix(1) ?? "P"
        let lastInitial = components.count > 1 ? components.last?.prefix(1) ?? "" : ""
        return "\(firstInitial)\(lastInitial)".uppercased()
    }
}

// MARK: - Balance Card

struct BalanceCard: View {
    let balance: Double
    let onAddFunds: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Dining Dollars")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Text(String(format: "$%.2f", balance))
                        .font(.system(size: 36, weight: .bold, design: .rounded))
                        .foregroundColor(.primary)
                }
                
                Spacer()
                
                Image(systemName: "creditcard.fill")
                    .font(.system(size: 40))
                    .foregroundColor(.blue)
            }
            
            Button {
                onAddFunds()
            } label: {
                HStack {
                    Image(systemName: "plus.circle.fill")
                    Text("Add $25")
                }
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(.blue)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(Color.blue.opacity(0.1))
                .clipShape(Capsule())
            }
        }
        .padding(20)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.05), radius: 8, y: 2)
    }
}

// MARK: - Dietary Preferences Card

struct DietaryPreferencesCard: View {
    let preferences: UserPreferences
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Dietary Preferences")
                .font(.headline)
            
            if preferences.activeDietaryRestrictions.isEmpty {
                Text("No dietary restrictions set")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            } else {
                FlowLayout(spacing: 8) {
                    ForEach(preferences.activeDietaryRestrictions, id: \.self) { restriction in
                        DietaryTag(text: restriction)
                    }
                }
            }
            
            Divider()
                .padding(.vertical, 4)
            
            HStack {
                Text("Max price per item")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Spacer()
                Text(String(format: "$%.2f", preferences.maxPricePerItem))
                    .font(.subheadline)
                    .fontWeight(.medium)
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.05), radius: 8, y: 2)
    }
}

struct DietaryTag: View {
    let text: String
    
    var body: some View {
        Text(text)
            .font(.caption)
            .fontWeight(.medium)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(tagColor.opacity(0.15))
            .foregroundColor(tagColor)
            .clipShape(Capsule())
    }
    
    private var tagColor: Color {
        switch text {
        case "Vegetarian": return .green
        case "Vegan": return .mint
        case "Gluten-Free": return .orange
        case "Halal": return .purple
        default: return .blue
        }
    }
}

// MARK: - Favorite Dining Halls Card

struct FavoriteDiningHallsCard: View {
    let favorites: [String]
    let allHalls: [DiningHall]
    let onToggleFavorite: (String) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Favorite Dining Halls")
                .font(.headline)
            
            ForEach(allHalls) { hall in
                HStack {
                    Text(hall.name)
                        .font(.subheadline)
                    
                    Spacer()
                    
                    Button {
                        onToggleFavorite(hall.name)
                    } label: {
                        Image(systemName: favorites.contains(hall.name) ? "heart.fill" : "heart")
                            .foregroundColor(favorites.contains(hall.name) ? .red : .gray)
                    }
                }
                .padding(.vertical, 4)
                
                if hall.id != allHalls.last?.id {
                    Divider()
                }
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.05), radius: 8, y: 2)
    }
}

// MARK: - Settings Card

struct SettingsCard: View {
    let onEditPreferences: () -> Void
    let onResetDefaults: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            Button {
                onEditPreferences()
            } label: {
                HStack {
                    Image(systemName: "slider.horizontal.3")
                        .foregroundColor(.blue)
                        .frame(width: 24)
                    Text("Edit Preferences")
                        .foregroundColor(.primary)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundColor(.secondary)
                        .font(.caption)
                }
                .padding()
            }
            
            Divider()
                .padding(.leading, 52)
            
            Button {
                onResetDefaults()
            } label: {
                HStack {
                    Image(systemName: "arrow.counterclockwise")
                        .foregroundColor(.orange)
                        .frame(width: 24)
                    Text("Reset to Defaults")
                        .foregroundColor(.primary)
                    Spacer()
                }
                .padding()
            }
        }
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.05), radius: 8, y: 2)
    }
}

// MARK: - Flow Layout for Tags

struct FlowLayout: Layout {
    var spacing: CGFloat = 8
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = FlowResult(
            in: proposal.width ?? 0,
            subviews: subviews,
            spacing: spacing
        )
        return result.size
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = FlowResult(
            in: bounds.width,
            subviews: subviews,
            spacing: spacing
        )
        
        for (index, subview) in subviews.enumerated() {
            subview.place(
                at: CGPoint(
                    x: bounds.minX + result.positions[index].x,
                    y: bounds.minY + result.positions[index].y
                ),
                proposal: .unspecified
            )
        }
    }
    
    struct FlowResult {
        var size: CGSize = .zero
        var positions: [CGPoint] = []
        
        init(in maxWidth: CGFloat, subviews: Subviews, spacing: CGFloat) {
            var x: CGFloat = 0
            var y: CGFloat = 0
            var rowHeight: CGFloat = 0
            
            for subview in subviews {
                let size = subview.sizeThatFits(.unspecified)
                
                if x + size.width > maxWidth, x > 0 {
                    x = 0
                    y += rowHeight + spacing
                    rowHeight = 0
                }
                
                positions.append(CGPoint(x: x, y: y))
                rowHeight = max(rowHeight, size.height)
                x += size.width + spacing
                
                self.size.width = max(self.size.width, x - spacing)
            }
            
            self.size.height = y + rowHeight
        }
    }
}

#Preview {
    ProfileView()
        .environmentObject(AppViewModel())
}
