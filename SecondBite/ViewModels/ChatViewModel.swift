//
//  ChatViewModel.swift
//  SecondBite
//
//  Created by David Cheng on 11/30/25.
//

import Foundation
import SwiftUI
import Combine

@MainActor
final class ChatViewModel: ObservableObject {
    
    @Published var messages: [ChatMessage] = []
    @Published var currentInput: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private let aiService = AIService.shared
    
    init() {
        // Add welcome message
        addWelcomeMessage()
    }
    
    private func addWelcomeMessage() {
        let welcomeMessage = ChatMessage(
            content: "Hi! I'm your Second Bite assistant. I can help you find the perfect leftover meal based on your dietary preferences and budget. What are you in the mood for today?",
            isFromUser: false
        )
        messages.append(welcomeMessage)
    }
    
    /// Send a message and get AI response
    func sendMessage(preferences: UserPreferences, diningHalls: [DiningHall]) async {
        let userText = currentInput.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !userText.isEmpty else { return }
        
        // Add user message
        let userMessage = ChatMessage(content: userText, isFromUser: true)
        messages.append(userMessage)
        
        // Clear input
        currentInput = ""
        isLoading = true
        errorMessage = nil
        
        do {
            let response = try await aiService.generateResponse(
                userMessage: userText,
                preferences: preferences,
                availableLeftovers: diningHalls
            )
            
            let aiMessage = ChatMessage(content: response, isFromUser: false)
            messages.append(aiMessage)
            
        } catch {
            errorMessage = error.localizedDescription
            let errorResponse = ChatMessage(
                content: "Sorry, I encountered an issue: \(error.localizedDescription). Please check your API key and internet connection.",
                isFromUser: false
            )
            messages.append(errorResponse)
        }
        
        isLoading = false
    }
    
    // Clear chat history and start fresh
    func clearChat() {
        messages.removeAll()
        addWelcomeMessage()
        errorMessage = nil
    }
    
    // Check if AI model is available
    var isModelAvailable: Bool {
        aiService.modelStatus == .available
    }
    
    // Get model status message for display
    var modelStatusMessage: String? {
        switch aiService.modelStatus {
        case .checking:
            return "Checking AI availability..."
        case .available:
            return nil
        case .unavailable(let reason):
            return reason
        }
    }
}
