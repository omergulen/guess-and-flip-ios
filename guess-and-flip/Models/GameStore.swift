import Foundation
import SwiftUI

class GameStore: ObservableObject {
    struct Tile: Identifiable {
        let id = UUID()
        var number: Int
        var isRevealed: Bool = false
        var isHinted: Bool = false
    }
    
    struct LevelConfig {
        let gridSize: Int
        let timeLimit: Int
        let maxHints: Int
    }
    
    static let levels: [LevelConfig] = [
        LevelConfig(gridSize: 2, timeLimit: 30, maxHints: 3),
        LevelConfig(gridSize: 3, timeLimit: 45, maxHints: 3),
        LevelConfig(gridSize: 4, timeLimit: 60, maxHints: 4),
        LevelConfig(gridSize: 5, timeLimit: 90, maxHints: 5)
    ]
    
    @Published var tiles: [Tile] = []
    @Published var currentNumber: Int = 1
    @Published var moves: Int = 0
    @Published var level: Int = 1
    @Published var score: Int = 0
    @Published var bestScore: Int = UserDefaults.standard.integer(forKey: "bestScore")
    @Published var hintsRemaining: Int
    @Published var timeRemaining: Int
    @Published var isGameWon: Bool = false
    
    private var timer: Timer?
    
    init() {
        let config = Self.levels[0]
        self.hintsRemaining = config.maxHints
        self.timeRemaining = config.timeLimit
        self.resetGame()
    }
    
    var currentLevelConfig: LevelConfig {
        Self.levels[level - 1]
    }
    
    func resetGame() {
        let config = currentLevelConfig
        tiles = []
        currentNumber = 1
        moves = 0
        hintsRemaining = config.maxHints
        timeRemaining = config.timeLimit
        isGameWon = false
        
        // Create shuffled tiles
        var numbers = Array(1...config.gridSize * config.gridSize)
        numbers.shuffle()
        
        for number in numbers {
            tiles.append(Tile(number: number))
        }
        
        startTimer()
    }
    
    func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            if self.timeRemaining > 0 {
                self.timeRemaining -= 1
            } else {
                self.resetGame()
            }
        }
    }
    
    func revealTile(_ index: Int) {
        guard !tiles[index].isRevealed else { return }
        
        tiles[index].isRevealed = true
        moves += 1
        
        if tiles[index].number == currentNumber {
            currentNumber += 1
            
            // Check if level is complete
            if currentNumber > tiles.count {
                levelComplete()
            }
        } else {
            // Wrong tile selected
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.tiles[index].isRevealed = false
            }
        }
    }
    
    func useHint() {
        guard hintsRemaining > 0 else { return }
        
        if let index = tiles.firstIndex(where: { $0.number == currentNumber && !$0.isRevealed }) {
            tiles[index].isHinted = true
            hintsRemaining -= 1
            
            // Remove hint after a delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                self.tiles[index].isHinted = false
            }
        }
    }
    
    private func levelComplete() {
        isGameWon = true
        timer?.invalidate()
        
        // Calculate score based on moves and time
        let baseScore = 1000
        let movesPenalty = moves * 10
        let timePenalty = (currentLevelConfig.timeLimit - timeRemaining) * 5
        let levelScore = max(0, baseScore - movesPenalty - timePenalty)
        score += levelScore
        
        if score > bestScore {
            bestScore = score
            UserDefaults.standard.set(bestScore, forKey: "bestScore")
        }
        
        // Advance to next level if available
        if level < Self.levels.count {
            level += 1
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                self.resetGame()
            }
        }
    }
    
    deinit {
        timer?.invalidate()
    }
}
