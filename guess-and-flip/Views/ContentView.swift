import SwiftUI

struct ContentView: View {
    @EnvironmentObject var gameStore: GameStore
    
    var body: some View {
        ZStack {
            Color(red: 0.102, green: 0.106, blue: 0.294)
                .ignoresSafeArea()
            
            ParticleBackgroundView()
            
            VStack(spacing: 24) {
                LevelInfoView()
                GameStatsView()
                GameBoardView()
                
                HStack(spacing: 16) {
                    Button(action: gameStore.resetGame) {
                        Image(systemName: "arrow.clockwise")
                            .font(.title2)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue.opacity(0.3))
                            .clipShape(Circle())
                    }
                    
                    Button(action: gameStore.useHint) {
                        HStack {
                            Image(systemName: "lightbulb.fill")
                            Text("\(gameStore.hintsRemaining)")
                        }
                        .font(.title2)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.yellow.opacity(0.3))
                        .clipShape(Capsule())
                    }
                    .disabled(gameStore.hintsRemaining == 0)
                }
            }
            .padding()
        }
    }
}
