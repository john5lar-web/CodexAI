import Foundation

struct Position: Hashable {
    let row: Int
    let col: Int

    func isAdjacent(to other: Position) -> Bool {
        let rowDelta = abs(row - other.row)
        let colDelta = abs(col - other.col)
        return (rowDelta == 1 && colDelta == 0) || (rowDelta == 0 && colDelta == 1)
    }
}

enum ItemType: CaseIterable {
    case leaf
    case berry
    case flower
    case stone
    case shell

    static func random() -> ItemType {
        ItemType.allCases.randomElement() ?? .leaf
    }
}

struct Tile: Identifiable {
    let id = UUID()
    let position: Position
    let type: ItemType
}

final class GameViewModel: ObservableObject {
    static let boardSize = 8

    @Published private(set) var board: [[ItemType]] = []
    @Published private(set) var score: Int = 0
    @Published var selected: Position? = nil

    init() {
        resetBoard()
    }

    func resetBoard() {
        board = (0..<Self.boardSize).map { _ in
            (0..<Self.boardSize).map { _ in ItemType.random() }
        }
        score = 0
        selected = nil
        resolveMatches()
    }

    func tile(at position: Position) -> Tile {
        Tile(position: position, type: board[position.row][position.col])
    }

    func tapTile(at position: Position) {
        if let selected = selected {
            if selected == position {
                self.selected = nil
                return
            }
            if selected.isAdjacent(to: position) {
                swapTiles(selected, position)
                if resolveMatches() {
                    self.selected = nil
                } else {
                    swapTiles(selected, position)
                    self.selected = nil
                }
                return
            }
        }
        selected = position
    }

    private func swapTiles(_ first: Position, _ second: Position) {
        let temp = board[first.row][first.col]
        board[first.row][first.col] = board[second.row][second.col]
        board[second.row][second.col] = temp
    }

    private func resolveMatches() -> Bool {
        var totalMatches = Set<Position>()
        totalMatches.formUnion(findLineMatches())

        guard !totalMatches.isEmpty else {
            return false
        }

        score += totalMatches.count * 10
        clear(matches: totalMatches)

        while resolveMatches() {}
        return true
    }

    private func findLineMatches() -> Set<Position> {
        var matches = Set<Position>()

        for row in 0..<Self.boardSize {
            var streakStart = 0
            for col in 1...Self.boardSize {
                let isEnd = col == Self.boardSize
                if isEnd || board[row][col] != board[row][col - 1] {
                    let streakLength = col - streakStart
                    if streakLength >= 4 {
                        for index in streakStart..<col {
                            matches.insert(Position(row: row, col: index))
                        }
                    }
                    streakStart = col
                }
            }
        }

        for col in 0..<Self.boardSize {
            var streakStart = 0
            for row in 1...Self.boardSize {
                let isEnd = row == Self.boardSize
                if isEnd || board[row][col] != board[row - 1][col] {
                    let streakLength = row - streakStart
                    if streakLength >= 4 {
                        for index in streakStart..<row {
                            matches.insert(Position(row: index, col: col))
                        }
                    }
                    streakStart = row
                }
            }
        }

        return matches
    }

    private func clear(matches: Set<Position>) {
        for match in matches {
            board[match.row][match.col] = ItemType.random()
        }
    }
}
