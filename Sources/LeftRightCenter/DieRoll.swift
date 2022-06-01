/// Represents one roll of a die
enum DieRoll: String {
	/// Pass a chip to the player on your left
	case left
	/// Pass a chip to the player on your right
	case right
	/// Place a chip in the center of the table
	case center
	/// Keep a chip for yourself
	case keep
}

/// All possible results from rolling a single die
let allRolls: [DieRoll] = [
	.left, .right, .center,
	.keep, .keep, .keep
]
