extends GridContainer

var excluded_cards = []
var selected_cards = [3]

func _ready() -> void:
	for child in get_children():
		child.reparent_requested.connect(_on_card_return)
	#RandomCardsArray()
		
		
func _on_card_return(child: CardUI) -> void:
	child.reparent(self)
	
func GetCard(index) -> CardUI:
	for child in get_children():
		if child.card.index == index:
			return child.Copy()
	return null

func GetCardArry(arr):
	var ret_arr:Array[CardUI] = []
	for i in arr:
		ret_arr.append(GetCard(i))
	return ret_arr

func FilterCard(card_list:Array):
	excluded_cards = GlobalUi.GetCardExcludeArray()
	selected_cards = GlobalUi.GetCardSelectArray()
	for card_num in excluded_cards:
		card_list.erase(card_num)
	for card_num in selected_cards:
		card_list.erase(card_num)
	card_list.shuffle()
	selected_cards.shuffle()
	for card_num in selected_cards:
		card_list.push_front(card_num)
	return card_list

func RandomEnemyBoard():
	var max_num = Global.team_size
	var enemy_cards:Array[CardUI] = [null,null,null,null,null,null]
	var card_list:Array = range(1,Global.MAX_CARDNUM)
	card_list = FilterCard(card_list)
	for card_index in card_list:
		var card = GetCard(card_index)
		if GetNotNullNum(enemy_cards) == max_num:
			break
		match card.card.prefer:
			"front":
				if  DealFrontCard(card,enemy_cards,max_num):
					continue
				pass
			"back":
				if DealBackCard(card,enemy_cards,max_num):
					continue

	var ret1 = GetCardsPos(enemy_cards)
	return [ret1[0],ret1[1]]

func RandomCardsArray():
	var max_num = Global.team_size
	var cards:Array[CardUI] = [null,null,null,null,null,null]
	var enemy_cards:Array[CardUI] = [null,null,null,null,null,null]
	var card_list:Array = range(1,Global.MAX_CARDNUM)
	card_list = FilterCard(card_list)

	for card_index in card_list:
		var card = GetCard(card_index)
		if GetNotNullNum(cards) == max_num and GetNotNullNum(enemy_cards) == max_num:
			break
		match card.card.prefer:
			"front":
				if DealFrontCard(card,cards,max_num):
					continue
				if  DealFrontCard(card,enemy_cards,max_num):
					continue
				pass
			"back":
				if DealBackCard(card,cards,max_num):
					continue
				if DealBackCard(card,enemy_cards,max_num):
					continue
			
			
	var ret1 = GetCardsPos(cards)
	var ret2 = GetCardsPos(enemy_cards)
	return [ret1[0],ret1[1],ret2[0],ret2[1]]

func DealFrontCard(card,card_array,max_num):
	var tempPos = randi_range(0,2)
	var time = 0
	if GetNotNullNum(card_array) >= max_num:
		return false
	while card_array[tempPos] != null and time < 3 :
		tempPos = (tempPos + 1) % 3
		time += 1
	if time < 3:
		card_array[tempPos] = card
		return true
	return false

func DealBackCard(card,card_array,max_num):
	var tempPos = randi_range(3,5)
	var time = 0
	if GetNotNullNum(card_array) >= max_num:
		return false
	while card_array[tempPos] != null and time < 3 :
		tempPos = (tempPos + 1) % 3 + 3
		time += 1
	if time < 3:
		card_array[tempPos] = card
		return true
	return false

func GetNotNullNum(array):
	var num = 0
	for i in array:
		if i != null:
			num+=1
	return num
		
func GetCardsPos(card_array):
	var ret = []
	for i in range(6):
		if card_array[i] != null:
			ret.append(i)
	var cards_new = card_array.filter(func(objetc): return objetc != null);
	return [cards_new,ret]

func GetCardArray(card_index_list):
	var ret1:Array[CardUI] = []
	var ret2 = []
	
	for i in range(card_index_list.size()):
		if card_index_list[i] != -1:
			ret1.append(GetCard(card_index_list[i]))
			ret2.append(i)
	return [ret1,ret2]

func CardNumToStr(cardnum):
	return GetCard(cardnum).name
	
