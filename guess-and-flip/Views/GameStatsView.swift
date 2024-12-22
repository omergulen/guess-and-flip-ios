import SwiftUI

struct GameStatsView: View {
    @EnvironmentObject var gameStore: GameStore
    
    var body: some View {
        HStack(spacing: 20) {
            StatItem(title: "Current", value: "\(gameStore.currentNumber)")
            StatItem(title: "Moves", value: "\(gameStore.moves)")
            StatItem(title: "Best", value: "\(gameStore.bestScore)")
        }
    }
}

struct StatItem: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack {
            Text(title)
                .font(.caption)
                .foregroundColor(.white.opacity(0.7))
            Text(value)
                .font(.title3)
                .bold()
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
        .background(Color.white.opacity(0.1))
        .cornerRadius(8)
    }
}
