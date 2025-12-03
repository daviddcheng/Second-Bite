//
//  AIService.swift
//  SecondBite
//
//  Created by David Cheng on 11/30/25.
//

import Foundation
import GoogleGenerativeAI
import Combine

@MainActor
final class AIService: ObservableObject {
    
    static let shared = AIService()
    
    // Load API key from Secrets.plist
    private static func loadAPIKey() -> String {
        guard let path = Bundle.main.path(forResource: "Secrets", ofType: "plist"),
              let dict = NSDictionary(contentsOfFile: path),
              let key = dict["GEMINI_API_KEY"] as? String else {
            fatalError("Secrets.plist not found or GEMINI_API_KEY missing. Please add Secrets.plist to your project.")
        }
        return key
    }
    
    private let apiKey: String
    private let model: GenerativeModel
    
    @Published var isProcessing: Bool = false
    @Published var modelStatus: ModelStatus = .available
    
    enum ModelStatus: Equatable {
        case checking
        case available
        case unavailable(String)
    }
    
    private init() {
        self.apiKey = Self.loadAPIKey()
        self.model = GenerativeModel(
            name: "gemini-2.5-flash",
            apiKey: apiKey,
            generationConfig: GenerationConfig(
                temperature: 0.7,
                topP: 0.95,
                topK: 40,
                maxOutputTokens: 500
            ),
            safetySettings: [
                SafetySetting(harmCategory: .harassment, threshold: .blockOnlyHigh),
                SafetySetting(harmCategory: .hateSpeech, threshold: .blockOnlyHigh),
                SafetySetting(harmCategory: .sexuallyExplicit, threshold: .blockOnlyHigh),
                SafetySetting(harmCategory: .dangerousContent, threshold: .blockOnlyHigh)
            ]
        )
        modelStatus = .available
    }
    
    func generateResponse(
        userMessage: String,
        preferences: UserPreferences,
        availableLeftovers: [DiningHall]
    ) async throws -> String {
        
        isProcessing = true
        defer { isProcessing = false }
        
        // Build the full prompt with context
        let fullPrompt = buildFullPrompt(
            userMessage: userMessage,
            preferences: preferences,
            availableLeftovers: availableLeftovers
        )
        
        do {
            let response = try await model.generateContent(fullPrompt)
            
            guard let text = response.text else {
                throw AIError.noResponse
            }
            
            return text.trimmingCharacters(in: .whitespacesAndNewlines)
        } catch {
            print("Gemini Error: \(error)")
            throw AIError.rateLimitExceeded
        }
    }
    
    private func buildFullPrompt(
        userMessage: String,
        preferences: UserPreferences,
        availableLeftovers: [DiningHall]
    ) -> String {
        var prompt = """
        You are a helpful food recommendation assistant for Second Bite, a college dining app that helps students find leftover food at reduced prices from Penn dining halls.
        
        Be friendly, concise, and helpful. When recommending food, always mention the dining hall name, item name, and price. Always consider the user's dietary restrictions carefully - never recommend food that violates their restrictions.

        DO NOT recommend food in markup. DO NOT use asterisks to indicate bolding. YOU ARE PRINTING RAW STRING.
        
        USER INFORMATION:
        - Name: \(preferences.name)
        - Balance: \(preferences.formattedBalance) dining dollars
        - Max price per item: $\(String(format: "%.2f", preferences.maxPricePerItem))
        """
        
        // Add dietary restrictions
        let restrictions = preferences.activeDietaryRestrictions
        if restrictions.isEmpty {
            prompt += "\n- Dietary restrictions: None"
        } else {
            prompt += "\n- Dietary restrictions: \(restrictions.joined(separator: ", ")) - IMPORTANT: Only recommend items that meet these requirements!"
        }
        
        // Add favorite dining halls if any
        if !preferences.favoriteDiningHalls.isEmpty {
            prompt += "\n- Favorite dining halls: \(preferences.favoriteDiningHalls.joined(separator: ", "))"
        }
        
        // Add available leftovers
        prompt += "\n\nCURRENTLY AVAILABLE LEFTOVERS:\n"
        
        for hall in availableLeftovers {
            prompt += "\n\(hall.name):\n"
            for item in hall.leftovers {
                var itemInfo = "  - \(item.name): \(item.formattedPrice), \(item.quantity) available"
                if !item.dietaryTags.isEmpty {
                    itemInfo += " [\(item.dietaryTags.joined(separator: ", "))]"
                }
                prompt += itemInfo + "\n"
            }
        }
        
        prompt += "\nKeep responses concise (2-3 sentences for simple questions, more for detailed recommendations). Be conversational and helpful."
        prompt += "\n\n---\nUSER MESSAGE: \(userMessage)"
        
        return prompt
    }
        
    enum AIError: LocalizedError {
        case noResponse
        case rateLimitExceeded
        
        var errorDescription: String? {
            switch self {
            case .noResponse:
                return "No response received from Gemini"
            case .rateLimitExceeded:
                return "YOUR API KEY HAS RUN OUT OF REQUESTS. PLEASE WAIT A MINUTE BEFORE RETRYING"
            }
        }
    }
}
