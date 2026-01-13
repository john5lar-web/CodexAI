import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = GameViewModel()

    private let columns = Array(repeating: GridItem(.flexible(), spacing: 6), count: GameViewModel.boardSize)

    var body: some View {
        VStack(spacing: 16) {
            header
            boardView
            controls
        }
        .padding()
        .background(Color(.systemGroupedBackground))
    }

    private var header: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Four in a Row Garden")
                    .font(.title2.bold())
                Text("Score: \(viewModel.score)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            Spacer()
        }
    }

    private var boardView: some View {
        LazyVGrid(columns: columns, spacing: 6) {
            ForEach(0..<GameViewModel.boardSize, id: \.self) { row in
                ForEach(0..<GameViewModel.boardSize, id: \.self) { col in
                    let position = Position(row: row, col: col)
                    let tile = viewModel.tile(at: position)
                    TileView(tile: tile, isSelected: viewModel.selected == position)
                        .onTapGesture {
                            viewModel.tapTile(at: position)
                        }
                }
            }
        }
        .padding(8)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.black.opacity(0.05))
        )
    }

    private var controls: some View {
        HStack {
            Button("New Game") {
                viewModel.resetBoard()
            }
            .buttonStyle(.borderedProminent)

            Text("Tap two adjacent tiles to swap.")
                .font(.footnote)
                .foregroundColor(.secondary)
        }
    }
}

struct TileView: View {
    let tile: Tile
    let isSelected: Bool

    var body: some View {
        RoundedRectangle(cornerRadius: 8)
            .fill(color(for: tile.type))
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(isSelected ? Color.yellow : Color.clear, lineWidth: 3)
            )
            .frame(width: 34, height: 34)
    }

    private func color(for type: ItemType) -> Color {
        switch type {
        case .leaf:
            return Color.green
        case .berry:
            return Color.pink
        case .flower:
            return Color.purple
        case .stone:
            return Color.gray
        case .shell:
            return Color.orange
        }
    }
}

#Preview {
    ContentView()
}
