struct Player {
	let name: String
	var chips: Int
}

//func lastPlayerLeft() -> Player? {
//	var playerWithChips: Player? = nil
//	for player in players {
//		if player.chips > 0 && playerWithChips == nil {
//			playerWithChips = player
//		} else if player.chips > 0 {
//			return nil
//		}
//	}
//	return playerWithChips
//}
//
//func someoneHasChipsLeft() -> Bool {
//	for player in players {
//		if player.chips > 0 {
//			return true
//		}
//	}
//	return false
//}
