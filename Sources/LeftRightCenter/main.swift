let playerNames = [
	"Tommy",
	"Justin",
	"Corey",
	"Christian",
	"Brad",
	"Chase",
	"Dalton"
]

//let initialChipCount = 3
//var players = playerNames.map { Player(name: $0, chips: initialChipCount) }
//var centerPool = 0
//var index = 0

//var lastPlayer: Player?
//while true {
//	let currentPlayerIndex = index % players.count
//	let leftIndex = (index + 1) % players.count
//	let rightIndex = (index - 1 + 6) % players.count
//
//	let playerName = players[currentPlayerIndex].name
//	let startingChips = players[currentPlayerIndex].chips
//
//	let numRolls = min(players[currentPlayerIndex].chips, initialChipCount)
//	if numRolls == 0 {
//		index += 1
//		continue
//	}
//
//	print("Current player is \(playerName) with \(startingChips) chips")
//	if let _lastPlayer = lastPlayer {
//		assert(_lastPlayer.name == playerName, "The player name is not correct. This should never happen.")
//		print("\(_lastPlayer.name) is rolling for the win!")
//	}
//	print("Press enter to roll...")
//	_ = readLine()
//
//	let rolls = (0..<numRolls).map { _ in allRolls.randomElement()! }
//
//	let rollsString = rolls.map(\.rawValue).joined(separator: ", ")
//	print("Player rolled: \(rollsString)")
//
//	for roll in rolls {
//		switch roll {
//		case .left:
//			players[currentPlayerIndex].chips -= 1
//			players[leftIndex].chips += 1
//		case .right:
//			players[currentPlayerIndex].chips -= 1
//			players[rightIndex].chips += 1
//		case .center:
//			players[currentPlayerIndex].chips -= 1
//			centerPool += 1
//		case .keep:
//			break
//		}
//	}
//
//	print("\(playerName) has \(players[currentPlayerIndex].chips) chips left.")
//
//	let nextLastPlayer = lastPlayerLeft()
//	if let _lastPlayer = lastPlayer {
//		if !someoneHasChipsLeft() {
//			print("Winner is \(_lastPlayer.name)!")
//			break
//		} else if let _nextLastPlayer = nextLastPlayer, _lastPlayer.name == _nextLastPlayer.name {
//			print("Winner is \(_lastPlayer.name)!")
//			break
//		}
//	}
//	lastPlayer = nextLastPlayer
//
//	print("Center pool is: \(centerPool).\n")
//	index += 1
//}
