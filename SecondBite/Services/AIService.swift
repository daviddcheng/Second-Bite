//
//  AIService.swift
//  SecondBite
//
//  Created by David Cheng on 11/30/25.
//

import Foundation
import FoundationModels
import Combine

/// Service for AI-powered food recommendations using Apple's Foundation Models
/// Implements on-device language model for privacy-preserving recommendations
@MainActor
final class AIService: ObservableObject {
    
    static let shared = AIService()
    
    @Published var isProcessing: Bool = false
    @Published var modelStatus: ModelStatus = .checking
    
    private var session: LanguageModelSession?
    
    enum ModelStatus: Equatable {
        case checking
        case available
        case unavailable(String)
    }
    
    private init() {
        Task {
            await checkModelAvailability()
        }
    }
    
    /// Check if Apple's on-device model is available
    func checkModelAvailability() async {
        let systemModel = SystemLanguageModel.default
        
        switch systemModel.availability {
        case .available:
            modelStatus = .available
            session = LanguageModelSession()
        case .unavailable(.appleIntelligenceNotEnabled):
            modelStatus = .unavailable("Please enable Apple Intelligence in Settings")
        case .unavailable(.deviceNotEligible):
            modelStatus = .unavailable("This device does not support Apple Intelligence")
        case .unavailable(.modelNotReady):
            modelStatus = .unavailable("Model is downloading, please try again shortly")
        @unknown default:
            modelStatus = .unavailable("Model unavailable")
        }
    }
    
    /// Generate AI response based on user message, preferences, and available leftovers
    func generateResponse(
        userMessage: String,
        preferences: UserPreferences,
        availableLeftovers: [DiningHall]
    ) async throws -> String {
        
        guard case .available = modelStatus, let session = session else {
            throw AIError.modelNotAvailable
        }
        
        isProcessing = true
        defer { isProcessing = false }
        
        let contextPrompt = buildContextPrompt(
            preferences: preferences,
            availableLeftovers: availableLeftovers
        )
        
        let fullPrompt = """
        \(contextPrompt)
        
        User message: \(userMessage)
        
        Provide a helpful, friendly, and concise response. If recommending food, mention the dining hall name, item name, and price. Consider dietary restrictions carefully.
        """
        
        let response = try await session.respond(to: Prompt(fullPrompt))
        return response.content.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    /// Build context string for AI prompt with all relevant information
    private func buildContextPrompt(
        preferences: UserPreferences,
        availableLeftovers: [DiningHall]
    ) -> String {
        var context = """
        You are a helpful food recommendation assistant for Second Bite, a college dining app that helps students find leftover food at reduced prices from Penn dining halls.
        
        USER PREFERENCES:
        - Name: \(preferences.name)
        - Balance: \(preferences.formattedBalance) dining dollars
        - Max price per item: $\(String(format: "%.2f", preferences.maxPricePerItem))
        """
        
        // Add dietary restrictions
        let restrictions = preferences.activeDietaryRestrictions
        if restrictions.isEmpty {
            context += "\n- Dietary restrictions: None"
        } else {
            context += "\n- Dietary restrictions: \(restrictions.joined(separator: ", "))"
        }
        
        // Add favorite dining halls if any
        if !preferences.favoriteDiningHalls.isEmpty {
            context += "\n- Favorite dining halls: \(preferences.favoriteDiningHalls.joined(separator: ", "))"
        }
        
        // Add available leftovers
        context += "\n\nCURRENTLY AVAILABLE LEFTOVERS:\n"
        
        for hall in availableLeftovers {
            context += "\n\(hall.name):\n"
            for item in hall.leftovers {
                var itemInfo = "  - \(item.name): \(item.formattedPrice), \(item.quantity) available"
                if !item.dietaryTags.isEmpty {
                    itemInfo += " [\(item.dietaryTags.joined(separator: ", "))]"
                }
                context += itemInfo + "\n"
            }
        }
        
        return context
    }
    
    enum AIError: LocalizedError {
        case modelNotAvailable
        
        var errorDescription: String? {
            switch self {
            case .modelNotAvailable:
                return "AI model is not available. Please check that Apple Intelligence is enabled."
            }
        }
    }
}
