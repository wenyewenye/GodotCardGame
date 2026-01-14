class_name GameTurn
extends Resource

var turn_count := 0
var isTurnChange := false


func IsTurnStateChange() -> bool:
	var tmp = isTurnChange
	isTurnChange = false
	return tmp

func TurnChange():
	isTurnChange = true
