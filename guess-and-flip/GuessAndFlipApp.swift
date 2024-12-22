import SwiftUI

@main
struct GuessAndFlipApp: App {
    @StateObject private var gameStore = GameStore()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(gameStore)
                .preferredColorScheme(.dark)
        }
    }
}
