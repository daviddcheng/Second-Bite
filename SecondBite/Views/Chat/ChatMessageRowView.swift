import SwiftUI

struct ChatMessageRowView: View {
    let message: ChatMessage
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 8) {
            if message.isFromUser {
                Spacer(minLength: 60)
            }
            
            VStack(alignment: message.isFromUser ? .trailing : .leading, spacing: 4) {
                Text(message.content)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 10)
                    .background(
                        message.isFromUser
                            ? Color.blue
                            : Color(.systemGray5)
                    )
                    .foregroundColor(message.isFromUser ? .white : .primary)
                    .clipShape(RoundedRectangle(cornerRadius: 18))
                
                Text(message.formattedTime)
                    .font(.caption2)
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 4)
            }
            
            if !message.isFromUser {
                Spacer(minLength: 60)
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 4)
    }
}

#Preview {
    VStack {
        ChatMessageRowView(message: ChatMessage(
            content: "Hi! What food recommendations do you have for me today?",
            isFromUser: true
        ))
        
        ChatMessageRowView(message: ChatMessage(
            content: "Based on your preferences, I'd recommend the Veggie Pasta Primavera at Kings Court English House. It's vegan, only $5.50, and they have 10 portions available!",
            isFromUser: false
        ))
    }
}
