extends Node


func GetRoundNum(_iswin,_turn_count,_teamCode,_teamCode2) -> bool: 
	return true

func GetWinNum(iswin,_turn_count,_teamCode,_teamCode2) -> bool: 
	return iswin


func ContainTeamIndex(index:int):
	var func_t = func(_iswin,_turn_count,teamCode,teamCode2):
		return teamCode & (1 << index) or teamCode2 & (1 << index)
	return func_t

func CountTeamIndexWin(index:int):
	var func_t = func(iswin,_turn_count,teamCode,teamCode2):
		if iswin:
			return teamCode & (1 << index)
		else:
			return teamCode2 & (1 << index)
	return func_t

func ContainTeamIndex1(index:int):
	var func_t = func(_iswin,_turn_count,teamCode,_teamCode2):
		return teamCode & (1 << index)
	return func_t

func ContainTeamIndex2(index:int):
	var func_t = func(_iswin,_turn_count,_teamCode,teamCode2):
		return teamCode2 & (1 << index)
	return func_t
	
func CountTeamIndexWin1(index:int):
	var func_t = func(iswin,_turn_count,teamCode,_teamCode2):
		return iswin and teamCode & (1 << index)
	return func_t
	
func CountTeamIndexWin2(index:int):
	var func_t = func(iswin,_turn_count,_teamCode,teamCode2):
		return not iswin and teamCode2 & (1 << index)
	return func_t
