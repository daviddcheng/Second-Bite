//
//  ProfileView.swift
//  SecondBite
//
//  Created by David Cheng on 11/30/25.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var appViewModel: AppViewModel
    @State private var showingPreferencesForm = false
    @State private var showingAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Profile Header Card
                    ProfileHeaderCard(preferences: appViewModel.userPreferences)
                    
                    // Balance Card
                    BalanceCard(
                        balance: appViewModel.userPreferences.balance,
                        onAddFunds: {
                            appViewModel.userPreferences.balance += 25.00
                            alertTitle = "Funds Added"
                            alertMessage = "Added $25.00 to your balance. New balance: \(appViewModel.userPreferences.formattedBalance)"
                            showingAlert = true
                        }
                    )
                    
                    // Dietary Preferences Card
                    DietaryPreferencesCard(preferences: appViewModel.userPreferences)
                    
                    // Favorite Dining Halls
                    FavoriteDiningHallsCard(
                        favorites: appViewModel.userPreferences.favoriteDiningHalls,
                        allHalls: appViewModel.diningHalls,
                        onToggleFavorite: { hallName in
                            if appViewModel.userPreferences.favoriteDiningHalls.contains(hallName) {
                                appViewModel.userPreferences.favoriteDiningHalls.removeAll { $0 == hallName }
                            } else {
                                appViewModel.userPreferences.favoriteDiningHalls.append(hallName)
                            }
                        }
                    )
                    
                    // Settings Section
                    SettingsCard(
                        onEditPreferences: {
                            showingPreferencesForm = true
                        },
                        onResetDefaults: {
                            appViewModel.userPreferences = UserPreferences()
                            alertTitle = "Reset Complete"
                            alertMessage = "Your preferences have been reset to defaults."
                            showingAlert = true
                        }
                    )
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Profile")
            .sheet(isPresented: $showingPreferencesForm) {
                PreferencesFormViewNew(appViewModel: appViewModel)
            }
            .alert(alertTitle, isPresented: $showingAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(alertMessage)
            }
        }
    }
}

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

struct PreferencesFormViewNew: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var appViewModel: AppViewModel
    
    // Local state for editing
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var isVegetarian: Bool = false
    @State private var isVegan: Bool = false
    @State private var requiresGlutenFree: Bool = false
    @State private var requiresHalal: Bool = false
    @State private var maxPrice: Double = 10.0
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Profile Information") {
                    TextField("Name", text: $name)
                        .textContentType(.name)
                    
                    TextField("Email", text: $email)
                        .textContentType(.emailAddress)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                }
                
                Section("Dietary Restrictions") {
                    Toggle("Vegetarian", isOn: $isVegetarian)
                        .onChange(of: isVegetarian) { _, newValue in
                            if !newValue {
                                isVegan = false
                            }
                        }
                    
                    Toggle("Vegan", isOn: $isVegan)
                        .onChange(of: isVegan) { _, newValue in
                            if newValue {
                                isVegetarian = true
                            }
                        }
                    
                    Toggle("Gluten-Free", isOn: $requiresGlutenFree)
                    
                    Toggle("Halal", isOn: $requiresHalal)
                }
                
                Section {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Maximum Price Per Item")
                            Spacer()
                            Text(String(format: "$%.2f", maxPrice))
                                .foregroundColor(.secondary)
                        }
                        
                        Slider(value: $maxPrice, in: 1...20, step: 0.50)
                            .tint(.blue)
                    }
                } header: {
                    Text("Budget")
                } footer: {
                    Text("Only show items at or below this price")
                }
            }
            .navigationTitle("Edit Preferences")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        savePreferences()
                        dismiss()
                    }
                    .fontWeight(.semibold)
                }
            }
            .onAppear {
                loadCurrentPreferences()
            }
        }
    }
    
    private func loadCurrentPreferences() {
        let prefs = appViewModel.userPreferences
        name = prefs.name
        email = prefs.email
        isVegetarian = prefs.isVegetarian
        isVegan = prefs.isVegan
        requiresGlutenFree = prefs.requiresGlutenFree
        requiresHalal = prefs.requiresHalal
        maxPrice = prefs.maxPricePerItem
    }
    
    private func savePreferences() {
        appViewModel.userPreferences.name = name
        appViewModel.userPreferences.email = email
        appViewModel.userPreferences.isVegetarian = isVegetarian
        appViewModel.userPreferences.isVegan = isVegan
        appViewModel.userPreferences.requiresGlutenFree = requiresGlutenFree
        appViewModel.userPreferences.requiresHalal = requiresHalal
        appViewModel.userPreferences.maxPricePerItem = maxPrice
    }
}

#Preview {
    ProfileView()
        .environmentObject(AppViewModel())
}
