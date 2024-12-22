import SwiftUI

struct GameBoardView: View {
    @EnvironmentObject var gameStore: GameStore
    
    var columns: [GridItem] {
        let config = gameStore.currentLevelConfig
        return Array(repeating: GridItem(.flexible(), spacing: 8), count: config.gridSize)
    }
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 8) {
            ForEach(Array(gameStore.tiles.enumerated()), id: \.element.id) { index, tile in
                GameTileView(tile: tile)
                    .onTapGesture {
                        withAnimation {
                            gameStore.revealTile(index)
                        }
                    }
            }
        }
        .padding(.horizontal)
    }
}

struct GameTileView: View {
    let tile: GameStore.Tile
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(backgroundColor)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.white.opacity(0.5), lineWidth: 2)
                )
            
            if tile.isRevealed {
                Text("\(tile.number)")
                    .font(.title)
                    .bold()
                    .foregroundColor(.white)
            }
            
            if tile.isHinted {
                Color.yellow
                    .opacity(0.3)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
        .aspectRatio(1, contentMode: .fit)
        .rotation3DEffect(
            .degrees(tile.isRevealed ? 0 : 180),
            axis: (x: 0.0, y: 1.0, z: 0.0)
        )
        .animation(.easeInOut(duration: 0.3), value: tile.isRevealed)
        .animation(.easeInOut(duration: 0.3), value: tile.isHinted)
    }
    
    private var backgroundColor: Color {
        if tile.isRevealed {
            return Color.blue.opacity(0.3)
        }
        return Color.gray.opacity(0.3)
    }
}
