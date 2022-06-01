/// The result of a single turn for a player
struct TurnResult {
	/// The player who took the turn
	let player: Player
	/// The die rolls for this turn
	let rolls: [DieRoll]
	/// The count of chips lost on this turn
	let chipsLost: Int
}

/// The core game algorithm and state
final class Game {
	/// The list of players in the game with their current chip counts
	private(set) var players: [Player]
	/// The initial count of chips disbursed to each player (e.g. 3)
	let initialChipCount: Int
	/// The zero-based turn index. This number is continually incremented, and the current
	/// player is derived from this number.
	private(set) var currentTurnIndex: Int = 0
	/// The count of chips in the center of the table
	private(set) var centerChipCount: Int = 0
	/// If the game is over, this field contains the winner
	private(set) var winner: Player?
	/// Whether the current player is rolling for the win
	private(set) var isCurrentPlayerRollingForWin: Bool = false

	/// The game is over if `winner` is not nil
	var isGameOver: Bool {
		winner != nil
	}

	/// The player who will roll next
	var currentPlayer: Player {
		let playerIndex = currentTurnIndex % players.count
		return players[playerIndex]
	}

	init(playerNames: [String], initialChipCount: Int = 3) {
		assert(playerNames.count > 1, "Must be at least two players")
		self.players = playerNames.map { Player(name: $0, chips: initialChipCount) }
		self.initialChipCount = initialChipCount
	}

	/// Advance gameplay by one turn
	func advanceNextTurn() -> TurnResult {
		guard isGameOver == false else {
			fatalError("Attempted to advance the turn after the game ended")
		}

		let currentPlayerIndex = currentTurnIndex % players.count
		// These two variables may seem like they're backwards, but if we assume that
		// gameplay is advancing clockwise, then the player to the "left" of the current
		// player is the next one in our list, so we use "plus 1" to get the left player.
		let leftIndex = (currentTurnIndex + 1) % players.count
		let rightIndex = (currentTurnIndex - 1 + 6) % players.count

		// Calculate the number of rolls the player gets, which is either their total
		// number of chips, or the initial chip count, whichever number is smaller.
		let numRolls = min(players[currentPlayerIndex].chips, initialChipCount)
		let rolls = (0..<numRolls).map { _ in allRolls.randomElement()! }

		var chipsLost = 0
		for roll in rolls {
			switch roll {
			case .left:
				players[currentPlayerIndex].chips -= 1
				players[leftIndex].chips += 1
				chipsLost += 1
			case .right:
				players[currentPlayerIndex].chips -= 1
				players[rightIndex].chips += 1
				chipsLost += 1
			case .center:
				players[currentPlayerIndex].chips -= 1
				centerChipCount += 1
				chipsLost += 1
			case .keep:
				break
			}
		}

		// Check if we have a winner
		if isCurrentPlayerRollingForWin {
			// If a player is rolling for the win and all of their rolls are either "keep"
			// or "center" (meaning none are "left" or "right"), then that player wins.
			let didWin = rolls.allSatisfy { $0 == .keep || $0 == .center }
			if didWin {
				winner = players[currentPlayerIndex]
			}
		}

		if isGameOver == false {
			advanceUntilNextPlayerWithChips()

			// Determine if the next player is rolling for the win
			let lastPlayerIndex = indexOfLastPlayerWithChips()
			isCurrentPlayerRollingForWin = lastPlayerIndex != nil
		}

		return TurnResult(
			player: players[currentPlayerIndex],
			rolls: rolls,
			chipsLost: chipsLost
		)
	}

	// MARK: - Helper functions

	/// Advance the `currentTurnIndex` until we find a player that still has chips
	private func advanceUntilNextPlayerWithChips() {
		for offset in (1..<players.count) {
			let playerIndex = (currentTurnIndex + offset) % players.count
			let player = players[playerIndex]
			if player.chips > 0 {
				currentTurnIndex += offset
				return
			}
		}
		fatalError("No players with chips. This should never happen.")
	}

	/// If there is one player left with chips, return the index of that player. Otherwise, return nil.
	private func indexOfLastPlayerWithChips() -> Int? {
		let playerIndiciesWithChips = players.indices.filter { players[$0].chips > 0 }
		return playerIndiciesWithChips.count == 1 ? playerIndiciesWithChips.first : nil
	}
}
