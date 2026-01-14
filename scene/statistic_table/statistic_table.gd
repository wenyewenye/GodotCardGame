extends Control

#@onready var canvas_rect: ReferenceRect = $TabContainer/CanvasRect
@onready var quit_button: Button = $QuitButton
@onready var bar_draw_canvas: Control = $TabContainer/BarDrawCanvas
@onready var game_recorder_table: Control = $TabContainer/GameRecorderTable


func _init() -> void:
	pass

	
func BindRecorder(recorderInput:GameRecorder):
	game_recorder_table.Bind(recorderInput)
	
	
func _ready() -> void:
	quit_button.pressed.connect(self.hide)
	pass

func initData(card_board,enemy_board):
	var statistic_array:Array[StatisticData] = []
	var img_array = []
	for card_ui in card_board.cards:
		if card_ui == null:
			statistic_array.append(null)
			img_array.append(null)
		else:
			statistic_array.append(card_ui.card.statisticData)
			img_array.append(card_ui.card.img)
	for card_ui in enemy_board.cards:
		if card_ui == null:
			statistic_array.append(null)
			img_array.append(null)
		else:
			statistic_array.append(card_ui.card.statisticData)
			img_array.append(card_ui.card.img)
	bar_draw_canvas.initData(statistic_array)
	bar_draw_canvas.InitImg(img_array)


func ReparseRoundData():
	game_recorder_table.ReparseRoundData()
