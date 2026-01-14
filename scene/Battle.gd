extends Node2D

@onready var card_board: CardBoard = $CardBoard
@onready var enemy_card_board: CardBoard = $EnemyCardBoard
@onready var card_repo: GridContainer = $RepoCanvas/ScrollContainer/CardRepo
@onready var menu_bar: MenuBar = $RepoCanvas/MenuBar
@onready var setting: Control = $WindowCanvas/Setting
@onready var statistic_table: Control = $WindowCanvas/StatisticTable
@onready var game_logger: GameLogger = $GameLogger
@onready var recorder: GameRecorder = $GameRecorder
@onready var background: Sprite2D = $background


@export var turn:GameTurn
var csvFile:FileAccess
var timeStr
var iswin = false
var sequence_win_count:int = 0
var start_time = 0.0

func _ready() -> void:
	LoadBackgroundImg()
	turn = GameTurn.new()
	RandomRound()
	InitMenu()
	statistic_table.BindRecorder(recorder)
	GlobalUi.RegisterCardRepo(card_repo)
	GlobalUi.show_card_select_view(get_global_mouse_position())
	

func LoadBackgroundImg():
	var dir:DirAccess = DirAccess.open("res://resourse/img/background/")
	var file_list:Array = dir.get_files()
	file_list = file_list.filter(func(filename:String): return filename.ends_with('.png'))
	
	background.texture = load(dir.get_current_dir() + "/" + file_list.pick_random())



func InitMenu():
	menu_bar.get_menu_popup(0).add_item("clear",1)
	menu_bar.get_menu_popup(0).add_item("setting",2)
	menu_bar.get_menu_popup(0).add_item("randomround",3)
	menu_bar.get_menu_popup(0).add_item("randomboard",4)
	menu_bar.get_menu_popup(0).add_item("graph",5)
	menu_bar.get_menu_popup(0).add_item("debug",6)
	menu_bar.get_menu_popup(0).add_item("teamgame",7)
	menu_bar.get_menu_popup(0).id_pressed.connect(_handle_menu)
	menu_bar.get_menu_popup(0).hide()



func _handle_menu(id):
	match id:
		1:  delete_temp()
		2:  setting.show()
		3:  RandomRound()
		4:	RandomBoard()
		5:	
			statistic_table.initData(card_board,enemy_card_board)
			statistic_table.show()
		6:  
			GlobalUi.GetCardSelectArray()
		7:  pass
			#statistic_table.ReparseRoundData()
				

func delete_temp():
	var dir = DirAccess.open(".//temp")
	var dir_path = dir.get_current_dir()
	dir.list_dir_begin()
	var file_name = dir.get_next()
	while file_name != "":
		if file_name != "." and file_name != "..":
			var full_path = dir_path.path_join(file_name)
			if dir.current_is_dir():
				pass
			else:
				# 删除文件
				game_logger.logFile.close()
				OS.move_to_trash(full_path)
				game_logger.logFile = FileAccess.open("./temp/log.txt",FileAccess.WRITE)
		file_name = dir.get_next()
	return true

	

func _process(delta: float) -> void:
	InputProcess();
	main()
	pass
	
	
func InputProcess():
	if Input.is_action_just_pressed("tab"):
		print("tab")
		card_repo.visible = not  card_repo.visible
	if Input.is_action_just_pressed("c"):
		start_time = Time.get_ticks_msec()
		turn.TurnChange()
	if Input.is_action_just_pressed("z"):
		GlobalUi._centre_container.visible = not  GlobalUi._centre_container.visible
		
		#container.add_child(GlobalUi._centre_container)
		
		pass
	

func main():
	
	if not turn.IsTurnStateChange():
		return
	turn.turn_count += 1
	TurnStart()
	Turn()
	TurnEnd()
		

func TurnStart():
	if turn.turn_count == 1:
		Events.setlog.emit("游戏开始",Events.LOGLEVEL.SYSTEM)
		for i in range(6):
			if card_board.cards[i] != null:
				card_board.cards[i].FirstAction()

			if enemy_card_board.cards[i] != null:
				enemy_card_board.cards[i].FirstAction()

	var logText = "turn start 当前回合数: {0}".format([turn.turn_count])
	Events.setlog.emit(logText,Events.LOGLEVEL.TURN)

	pass
func TurnEnd():
	var logText = "turn end 当前回合数: {0}".format([turn.turn_count])
	Events.setlog.emit(logText,Events.LOGLEVEL.TURN)
	if Global.isFastMode and DealTurnEnd():
		turn.TurnChange()
		
func Turn():
	for i in range(6):
		if card_board.cards[i] != null:
			card_board.cards[i].Action()
			if not Global.isFastMode:
				await get_tree().create_timer(1).timeout

				
		if enemy_card_board.cards[i] != null:
			enemy_card_board.cards[i].Action()
			if not Global.isFastMode:
				await get_tree().create_timer(1).timeout
	pass

func DealTurnEnd():
	if not IsVictory():
		return true
	
	Events.setlog.emit("游戏结算",Events.LOGLEVEL.SYSTEM)
	Settlement()
	
	return StartNewTurn()

func IsVictory()->bool:
	if enemy_card_board.cards.all(func(card):return card == null or card.isLive() == false):
		Events.setlog.emit("胜利\n",Events.LOGLEVEL.SYSTEM)
		iswin = true
	else: 
		if card_board.cards.all(func(card):return card == null or card.isLive() == false):
			Events.setlog.emit("失败\n",Events.LOGLEVEL.SYSTEM)
			iswin = false
		else:
			if turn.turn_count < 60:
				return false
			iswin = false
	return true

func StartNewTurn():
	if Global.isFastMode:
		if Global.Times != 0:
			if Global.type == 'round':
				RandomRound()
			elif Global.type == 'board':
				RandomBoard()
			elif Global.type == 'spiremode':
				SpireMode()
				if sequence_win_count == Global.MAX_WIN_COUNT:
					return false
			
			Global.Times -= 1;
			return true
	return false

func Reset():
	RemoveCardUI(enemy_card_board)
	RemoveCardUI(card_board)
	turn.turn_count = 0
	var end_timer = Time.get_ticks_msec() - start_time
	print(str(Global.Times) + "\t 本轮耗时：" + str(end_timer) + "\t"  \
	+ str(sequence_win_count) + "\t"   \
	+ str(iswin))
	start_time = Time.get_ticks_msec()
	
func Settlement():
	SaveCSVFile()
	game_logger.SaveLogTxt()
	

func RemoveCardUI(board):
	for card in board.cards:
		if card == null:
			continue
		card.free()
		card = null

func SaveCSVFile():
	SaveHeroFile()

func SaveHeroFile():
	if not FileAccess.file_exists("res://temp//save_game.csv"):
		csvFile = FileAccess.open("res://temp//save_game.csv", FileAccess.WRITE)
		var hardList = ["index","name","造成伤害","承受伤害","造成治疗","收到治疗","有效护盾","击杀数","位置","胜利","描述","时间戳"]
		csvFile.store_csv_line(hardList)
	else:
		csvFile = FileAccess.open("res://temp//save_game.csv", FileAccess.READ_WRITE)
		if csvFile != null:
			csvFile.seek_end()
			csvFile.store_csv_line([])
		
	timeStr = Time.get_date_string_from_system() + " " + Time.get_time_string_from_system()
	SaveBoardData(card_board,iswin,"mate")
	SaveBoardData(enemy_card_board,not iswin,"enemy")
	if csvFile != null:
		csvFile.close()
	recorder.RecordRound(card_board.cards,enemy_card_board.cards,iswin,turn.turn_count)
	
func SaveBoardData(board,iswin,info_str):
	for card_ui in board.cards:
		if card_ui == null:
			continue
		var list = [
			card_ui.card.index,
			card_ui.card.name,
			card_ui.card.statisticData.damageMaking,
			card_ui.card.statisticData.damageTaking,
			card_ui.card.statisticData.healMaking,
			card_ui.card.statisticData.healTaking,
			card_ui.card.statisticData.blockUsed,
			card_ui.card.statisticData.kill,
			card_ui.card.pos,
			iswin,
			info_str,
			timeStr
			]
		if csvFile != null:
			csvFile.store_csv_line(list)

func GetRandom(min_v=0,max_v=Global.MAX_VALUE,n=3):
	var numbers = range(min_v,max_v)
	numbers.shuffle()
	return numbers.slice(0,n)

func RandomBoard():
	var card_index_list = card_board.GetCardIndex()
	Reset()
	var temp = card_repo.RandomEnemyBoard()
	enemy_card_board.SetCardPos(temp[0],temp[1])
	var temp1 = card_repo.GetCardArray(card_index_list)
	card_board.SetCardPos(temp1[0],temp1[1])
	
func RandomRound():
	Reset()
	var temp = card_repo.RandomCardsArray()
	card_board.SetCardPos(temp[0],temp[1])
	enemy_card_board.SetCardPos(temp[2],temp[3])

func SpireMode():
	var card_index_list = []
	if iswin:
		card_index_list = card_board.GetCardIndex()
		sequence_win_count += 1
	else:
		card_index_list = enemy_card_board.GetCardIndex()
		sequence_win_count = 1
	if sequence_win_count == Global.MAX_WIN_COUNT:
		print(card_board.GetCardIndex())
		print(card_board.GetCardIndex().map(card_repo.CardNumToStr))
		return
	Reset()
	var temp = card_repo.RandomEnemyBoard()
	enemy_card_board.SetCardPos(temp[0],temp[1])
	var temp1 = card_repo.GetCardArray(card_index_list)
	card_board.SetCardPos(temp1[0],temp1[1])
	
