//
//  PreferencesFormView.swift
//  SecondBite
//
//  Created by David Cheng on 11/30/25.
//

import SwiftUI
import Combine

struct PreferencesFormView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: ProfileViewModel
    
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
                            // Vegan implies vegetarian
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
        let prefs = viewModel.preferences
        name = prefs.name
        email = prefs.email
        isVegetarian = prefs.isVegetarian
        isVegan = prefs.isVegan
        requiresGlutenFree = prefs.requiresGlutenFree
        requiresHalal = prefs.requiresHalal
        maxPrice = prefs.maxPricePerItem
    }
    
    private func savePreferences() {
        var updatedPrefs = viewModel.preferences
        updatedPrefs.name = name
        updatedPrefs.email = email
        updatedPrefs.isVegetarian = isVegetarian
        updatedPrefs.isVegan = isVegan
        updatedPrefs.requiresGlutenFree = requiresGlutenFree
        updatedPrefs.requiresHalal = requiresHalal
        updatedPrefs.maxPricePerItem = maxPrice
        
        viewModel.updatePreferences(updatedPrefs)
    }
}

#Preview {
    PreferencesFormView(viewModel: ProfileViewModel())
}
