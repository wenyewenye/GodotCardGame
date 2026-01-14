extends Node
class_name  GameRecorder

var func_list:Array[Callable] = []
var csvFile:FileAccess
@onready var card_repo: GridContainer = get_node("%CardRepo")
@warning_ignore("unused_signal")
signal setprogress(value:int)


func _init() -> void:
	return
	#ResigerFunc(func(arguments: Array): arguments[2] == 1)

func RecordRound(cards:Array[CardUI],enemy_cards:Array[CardUI],iswin,turn_count):
	var tmpFile:FileAccess
	if not FileAccess.file_exists("res://temp//round_date.dat"):
		tmpFile = FileAccess.open("res://temp//round_date.dat", FileAccess.WRITE)
	else:
		tmpFile = FileAccess.open("res://temp//round_date.dat", FileAccess.READ_WRITE)
		tmpFile.seek_end()
	tmpFile.store_8(iswin)
	tmpFile.store_32(turn_count)
	tmpFile.store_64(GetTeamCode(cards))
	tmpFile.store_64(GetTeamCode(enemy_cards))
	tmpFile.close()
	pass

func ReparseRoundData():
	if not FileAccess.file_exists("res://temp//round_date.dat"):
		return
	else:
		csvFile = FileAccess.open("res://temp//round_date.dat", FileAccess.READ)
		
	var ret_arr = []
	var count = 0;
	ret_arr.resize(func_list.size())
	ret_arr.fill(0)
	while not csvFile.eof_reached():
		var iswin = csvFile.get_8()
		if csvFile.eof_reached():
			break
		var turn_count = csvFile.get_32()
		var teamCode = csvFile.get_64()
		var teamCode2 = csvFile.get_64()
		#var test_log = str(iswin) + " " + str(turn_count) + "|" + ",".join(TeamCodeToNum(teamCode)) + " VS " + ",".join(TeamCodeToNum(teamCode2))
		if count % 100 == 0:
			Events.set_store_data.emit(str(count))
		
		for i in range(func_list.size()):
			var funcs:Callable = func_list[i]
			if funcs.callv([iswin,turn_count,teamCode,teamCode2]):
				ret_arr[i] = ret_arr[i] + 1
		count += 1
	csvFile.close()
	return ret_arr


func ResigerFunc(funcs:Callable):
	func_list.append(funcs)

func Clear():
	func_list = [] 

func GetTeamCode(cards:Array[CardUI]):
	var code:int = 0
	for i in range(cards.size()):
		if cards[i] != null:
			code = code | (1 << cards[i].card.index)
	return code
		
func TeamCodeToNum(teamCode):
	var array = [];
	for i in range(0,64):
		if (teamCode & (1 << i) != 0):
			array.append(card_repo.CardNumToStr(i));
	
	return array
	
