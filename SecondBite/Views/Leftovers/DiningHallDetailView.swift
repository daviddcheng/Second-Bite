import SwiftUI

struct DiningHallDetailView: View {
    @EnvironmentObject var appViewModel: AppViewModel
    let hall: DiningHall
    
    @State private var showingAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                heroImage
                infoSection
                statsSection
                leftoversSection
                reserveSection
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
            .padding(.bottom, 32)
        }
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
        .navigationTitle(hall.name)
        .navigationBarTitleDisplayMode(.inline)
        .alert(alertTitle, isPresented: $showingAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(alertMessage)
        }
    }
        
    private var heroImage: some View {
        ZStack(alignment: .bottomLeading) {
            // Dining hall hero image
            Image(hall.imageName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 220)
                .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                .overlay(
                    // Dark gradient overlay
                    LinearGradient(
                        colors: [
                            Color.clear,
                            Color.black.opacity(0.7)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                )
            
            VStack(alignment: .leading, spacing: 6) {
                Text("Surprise Bag")
                    .font(.footnote.weight(.semibold))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(
                        Capsule().fill(Color.white.opacity(0.9))
                    )
                
                Text(hall.name)
                    .font(.title2.bold())
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
            .padding(16)
        }
    }
    
    private var infoSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("About this Surprise Bag")
                .font(.headline)
            
            Text(hall.description)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var statsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Overall experience")
                .font(.headline)
            
            HStack(alignment: .center, spacing: 16) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("4.6")
                        .font(.largeTitle.bold())
                    Text("Based on recent student ratings")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                VStack(alignment: .leading, spacing: 8) {
                    statRow(title: "Pickup", value: 4.8)
                    statRow(title: "Quality", value: 4.4)
                    statRow(title: "Variety", value: 4.3)
                    statRow(title: "Quantity", value: 4.5)
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .fill(Color(.systemBackground))
                    .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
            )
        }
    }
    
    private func statRow(title: String, value: Double) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(title)
                    .font(.caption)
                Spacer()
                Text(String(format: "%.1f", value))
                    .font(.caption.weight(.semibold))
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Color.gray.opacity(0.15))
                        .frame(height: 4)
                    Capsule()
                        .fill(Color.green.opacity(0.85))
                        .frame(width: geometry.size.width * CGFloat(value / 5.0), height: 4)
                }
            }
            .frame(height: 4)
        }
    }
    
    private var leftoversSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Possible items")
                .font(.headline)
            
            ForEach(hall.leftovers) { item in
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(item.name)
                            .font(.subheadline.weight(.medium))
                        Text("\(item.quantity) portions remaining")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    
                    Spacer()
                    
                    HStack(spacing: 4) {
                        if item.isVegetarian {
                            tag("Veg")
                        }
                        if item.isVegan {
                            tag("Vegan")
                        }
                        if item.isGlutenFree {
                            tag("GF")
                        }
                    }
                }
                .padding(.vertical, 6)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private func tag(_ text: String) -> some View {
        Text(text)
            .font(.caption2.weight(.semibold))
            .padding(.horizontal, 6)
            .padding(.vertical, 3)
            .background(
                Capsule().fill(Color.green.opacity(0.14))
            )
    }
    
    private var reserveSection: some View {
        VStack(spacing: 12) {
            HStack(alignment: .firstTextBaseline) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("$15.00")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .strikethrough()
                    Text("$10.00")
                        .font(.title2.bold())
                        .foregroundStyle(Color.green.opacity(0.9))
                    Text("You’ll be charged from your dining balance.")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text("Balance")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                    Text("$\(Int(appViewModel.diningBalance))")
                        .font(.headline.weight(.semibold))
                }
            }
            
            Button(action: reserve) {
                Text(appViewModel.diningBalance >= 10 ? "Reserve" : "Insufficient balance")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .fill(appViewModel.diningBalance >= 10 ? Color.green.opacity(0.9) : Color.gray)
                    )
                    .foregroundStyle(Color.white)
            }
            .disabled(appViewModel.diningBalance < 10)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.06), radius: 10, x: 0, y: 6)
        )
    }
    
    private func reserve() {
        let success = appViewModel.reserve(from: hall)
        if success {
            alertTitle = "Reservation Confirmed!"
            alertMessage = "Your surprise bag from \(hall.name) has been reserved. New balance: \(appViewModel.userPreferences.formattedBalance)"
        } else {
            alertTitle = "Insufficient Balance"
            alertMessage = "You need at least $10.00 to reserve a surprise bag. Current balance: \(appViewModel.userPreferences.formattedBalance)"
        }
        showingAlert = true
    }
}

#Preview {
    NavigationStack {
        DiningHallDetailView(hall: SampleData.halls[0])
            .environmentObject(AppViewModel())
    }
}


