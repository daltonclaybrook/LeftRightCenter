let playerNames = [
	"Tommy",
	"Justin",
	"Corey",
	"Christian",
	"Brad",
	"Chase",
	"Dalton"
].shuffled()

let game = Game(playerNames: playerNames)

while game.isGameOver == false {
	let currentPlayer = game.currentPlayer
	print("It's \(currentPlayer.name)'s turn with \(currentPlayer.chips) chips")
	if game.isCurrentPlayerRollingForWin {
		print("\(currentPlayer.name) is rolling for the win!")
	}

	print("Press enter to roll...", terminator: "")
	_ = readLine() // Halt until player hits enter

	let result = game.advanceNextTurn()
	let rollsString = result.rolls.map(\.rawValue).joined(separator: ", ")
	print("\(currentPlayer.name) rolled: \(rollsString). They lost \(result.chipsLost) chips. They have \(result.player.chips) chips left.")
	print("There are \(game.centerChipCount) chips in the center\n")
}

let winner = game.winner!
print("The winner is \(winner.name)! They finished with \(winner.chips) chips.")
