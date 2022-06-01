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
	/// The index of the player that is currently rolling for the win, if there is one
	private var playerRollingForWinIndex: Int?

	/// The game is over if `winner` is not nil
	var isGameOver: Bool {
		winner != nil
	}

	/// The player who will roll next
	var currentPlayer: Player {
		let playerIndex = currentTurnIndex % players.count
		return players[playerIndex]
	}

	/// The player that is currently rolling for the win, if there is one
	var playerRollingForWin: Player? {
		playerRollingForWinIndex.map { players[$0] }
	}

	init(players: [Player], initialChipCount: Int = 3) {
		assert(!players.isEmpty, "Players must not be empty")
		self.players = players
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
		if let playerRollingForWin = playerRollingForWin {
			// If a player is rolling for the win and all of their rolls are either "keep"
			// or "center" (meaning none are "left" or "right"), then that player wins.
			let didWin = rolls.allSatisfy { $0 == .keep || $0 == .center }
			if didWin {
				winner = playerRollingForWin
			}
		}

		// If only one player has chips left, that player will roll for the win on the next turn
		playerRollingForWinIndex = indexOfLastPlayerWithChips()
		if isGameOver == false {
			advanceUntilNextPlayerWithChips()
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
		for offset in players.indices {
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
