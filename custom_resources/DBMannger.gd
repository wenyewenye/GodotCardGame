class_name DBMannger
var db: SQLite
var current_round_id:int = 0 

func _init() -> void:
	db = SQLite.new()
	db.path = "res://db//game_data.db"
	db.verbosity_level = SQLite.VerbosityLevel.NORMAL
	
	# 打开或创建数据库
	if db.open_db():
		push_error("无法打开数据库")
	get_hero_data('sonida')
	#db.query("INSERT INTO round_data(turn_num,iswin,card1,enemycard1)VALUES(10,false,'sonida','monje');")
	
func execute(cmd:String):
	db.query(cmd)

func insert_round(board,enemyboard,iswin,turn_num):
	var item_head:String = "INSERT INTO round_data(turn_num,iswin,card1,card2,card3,card4,card5,card6,
		enemycard1,enemycard2,enemycard3,enemycard4,enemycard5,enemycard6)"
	var item:String = "VALUES(" + str(turn_num) + "," + str(iswin) 
	for card in board.cards:
		if card == null:
			item += ",''"
		else:
			item +=   ",\"" + card.name + "\""
	
	for card in enemyboard.cards:
		if card == null:
			item += ",''"
		else:
			item +=   ",\"" + card.name + "\""
	item += ")"
	execute(item_head + item)
	current_round_id = db.last_insert_rowid

	insert_hero(board,current_round_id)
	insert_hero(enemyboard,current_round_id)
	#db.select_rows("round_data","card1 != \'\' OR card2 != \'\' ",["card1"])
	
	pass

func get_hero_data(name):
	db.select_rows("round_data","card1 == \'{0}\' OR card2 == \'{0}\' OR card3 == \'{0}\' 
		OR card4 == \'{0}\' OR card5 == \'{0}\' OR card6 == \'{0}\'
		OR enemycard1 == \'{0}\' OR enemycard2 == \'{0}\' OR enemycard3 == \'{0}\'
		OR enemycard4 == \'{0}\' OR enemycard5 == \'{0}\' OR enemycard6 == \'{0}\' ".format([name]),["*"])
	db.select_rows("round_data","card1 == \'{0}\' OR card2 == \'{0}\' OR card3 == \'{0}\' 
		OR card4 == \'{0}\' OR card5 == \'{0}\' OR card6 == \'{0}\'
		OR enemycard1 == \'{0}\' OR enemycard2 == \'{0}\' OR enemycard3 == \'{0}\'
		OR enemycard4 == \'{0}\' OR enemycard5 == \'{0}\' OR enemycard6 == \'{0}\'".format([name]),["*"])
	print(db.query_result.size())

func insert_hero(board,round_id):
	for card_ui in board.cards:
		if card_ui == null:
			return
		var data = card_ui.card.statisticData
		var item_head:String = "INSERT INTO statistic_data(name,card_id,round_id,damageTaking,
			damageMaking,healTaking,healMaking,kill,block)"
		var value_string = "VALUES(\"{0}\",{1},{2},{3},{4},{5},{6},{7},{8})".format([card_ui.card.name,
			card_ui.card.index,round_id,data.damageTaking,data.damageMaking,
			data.healTaking,data.healMaking,data.kill,data.blockUsed])
		execute(item_head + value_string)
