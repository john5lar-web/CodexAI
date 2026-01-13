# Four in a Row Garden (iOS)

This is a lightweight SwiftUI prototype for a Gardenscapes-style match game that focuses on swapping items to create **4-in-a-row** matches. It is designed for an Xcode iOS app target.

## How to use in Xcode
1. Create a new **App** project in Xcode (SwiftUI, iOS).
2. Replace the generated `ContentView.swift` and `App` file with the files in `FourInARow/`.
3. Build and run on an iOS Simulator.

## Gameplay
- Tap a tile to select it.
- Tap an adjacent tile to swap.
- If the swap creates a 4+ match, it clears and respawns the tiles.
- Score is updated for every matched tile.

## Files
- `FourInARowApp.swift` — entry point.
- `ContentView.swift` — UI layout.
- `GameLogic.swift` — board setup, swap logic, and match detection.
