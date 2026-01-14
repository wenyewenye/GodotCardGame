extends Node

func GetFirst(cards:Array[CardUI]) -> Array[int]: 
	var arr : Array[int] = []
	arr.append(cards.find_custom(func(value): return value != null and value.card.CanAttacked() == true))
	arr.erase(-1) #除去没找到的情况
	return arr

func GetNormal(cards:Array[CardUI],pos):
	var enemy_list = GetAll(cards)
	var index1 = enemy_list.find(FrontPos(pos))
	var index2 = enemy_list.find(BackPos(pos))
	if index1 != -1: return [enemy_list.get(index1)]
	if index2 != -1: return [enemy_list.get(index2)]
	enemy_list.erase(-1) #除去没找到的情况
	if enemy_list.is_empty():return [] 
	else: return [enemy_list[0]] 

func GetCol(cards:Array[CardUI],pos):
	var enemy_list = GetNormal(cards,pos)
	if enemy_list.is_empty(): return []
	var first = enemy_list[0]
	var second = (first + 3) % 6
	if  cards[second] != null and cards[second].card.stat.islive == true:
		return [first,second]
	return [first]

func GetFirstPos(cards:Array[CardUI]) -> int:
	return cards.find_custom(func(value): return value != null and value.card.stat.islive == true)

func GetLowHP(cards:Array[CardUI], isHeal = false) -> Array[int]:
	var live_list:Array[int] = GetAll(cards)
	var min_value = Global.MAX_VALUE
	var min_pos = -1
	for i in live_list:
		if not isHeal or cards[i].card.stat.health != cards[i].card.stat.max_health:
			if min_value > cards[i].card.stat.health:
				min_pos = i
				min_value = cards[i].card.stat.health
	if min_pos == -1:
		return []
	return [min_pos]

func GetLowPercentHP(cards:Array[CardUI], size = 1) -> Array[int]:
	var list = []
	var index_list = []
	var live_list:Array[int] = GetAll(cards)
	for i in live_list:
		var ratio = float(cards[i].card.stat.health)/float(cards[i].card.stat.max_health)
		list.append(ratio)
		index_list.append(i)
	var indices = range(list.size())
	indices.sort_custom(func(a, b): return list[a] < list[b])
	var ret:Array[int] = []
	for idx in indices:
		ret.append(index_list[idx])
	var ret_size = min(size,index_list.size())
	return ret.slice(0, ret_size)


func GetAll(cards:Array[CardUI]) -> Array[int]:
	var arr:Array[int] = [0,1,2,3,4,5]
	arr = arr.filter(func(i): return cards[i] != null and cards[i].card.stat.islive == true)
	return arr

func FrontPos(v:int):
	if v > 2:
		return v -3
	return v

func BackPos(v:int):
	if v < 3:
		return v + 3
	return v  
	
