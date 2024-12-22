import SwiftUI

struct LevelInfoView: View {
    @EnvironmentObject var gameStore: GameStore
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Level \(gameStore.level)")
                    .font(.title2)
                    .bold()
                Text("Score: \(gameStore.score)")
                    .font(.headline)
            }
            
            Spacer()
            
            Text(timeString)
                .font(.title)
                .bold()
                .foregroundColor(gameStore.timeRemaining < 10 ? .red : .white)
        }
        .foregroundColor(.white)
        .padding()
        .background(Color.black.opacity(0.3))
        .cornerRadius(12)
    }
    
    private var timeString: String {
        let minutes = gameStore.timeRemaining / 60
        let seconds = gameStore.timeRemaining % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
