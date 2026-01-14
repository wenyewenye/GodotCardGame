extends Control

var recorder:GameRecorder
@onready var card_repo: GridContainer = get_node("/root/Battle").get_node("%CardRepo")
@onready var test: Button = $test
@onready var info_edit: TextEdit = $infoEdit

@onready var friend_conition_contain: VBoxContainer = $FriendConitionContain
@onready var enemy_conition_contain: VBoxContainer = $EnemyConitionContain

@onready var total: Label = $HBoxContainer/total
@onready var count: Label = $HBoxContainer/count
@onready var ratio: Label = $HBoxContainer/Ratio
@onready var progress_bar: ProgressBar = $ProgressBar
@onready var trigger_button: Button = $TriggerButton



func _ready() -> void:
	test.pressed.connect(self.ButtonPressed)
	trigger_button.pressed.connect(self.CalculateSpecialData)
	Events.set_store_data.connect(on_store_data)
	
func on_store_data(text:String):
	total.text = text
	
func ButtonPressed():
	ReparseRoundData()
	
func Bind(recorderInput:GameRecorder):
	recorder = recorderInput
	#progress_bar.connect()


func ReparseRoundData():
	var text = "" 
	for i in range(Global.MAX_CARDNUM - 1):
		recorder.ResigerFunc(StatisticMethod.ContainTeamIndex(i + 1))
		recorder.ResigerFunc(StatisticMethod.CountTeamIndexWin(i + 1))
		
		
	#spin_box_total.prefix = card_repo.CardNumToStr(spin_box_total.value)
	
	var ret = recorder.ReparseRoundData()
	if ret == null:
		return
	for i in range(Global.MAX_CARDNUM - 1):
		text += str(i + 1) + " " + card_repo.CardNumToStr(i + 1) + "\t"
		text += " 总场：" + str(ret[i * 2]) + " 胜场：" + str(ret[i * 2 + 1]) +  \
			" 胜率：" + "%.2f" % (float(ret[2 * i + 1]) / float(ret[i * 2 ]) * 100) + "%\n"
	recorder.Clear()
	
	info_edit.clear()
	info_edit.text = text
	
func CalculateSpecialData():
	var list = []
	var list_enemy = []
	for spin in friend_conition_contain.get_children():
		if spin.value == 0:
			continue
		spin.prefix = card_repo.CardNumToStr(spin.value)
		list.append(StatisticMethod.ContainTeamIndex1(spin.value))
		list_enemy.append(StatisticMethod.ContainTeamIndex2(spin.value))
	for spin in enemy_conition_contain.get_children():
		if spin.value == 0:
			continue
		spin.prefix = card_repo.CardNumToStr(spin.value)
		list.append(StatisticMethod.ContainTeamIndex2(spin.value))
		list_enemy.append(StatisticMethod.ContainTeamIndex1(spin.value))
	
	var func_t1 = func(iswin,_turn_count,teamCode,teamCode2):
		var ret1 = true
		var ret2 = true
		for func_val in list:
			ret1 = ret1 and func_val.callv([iswin,_turn_count,teamCode,teamCode2])
		for func_val in list_enemy:
			ret2 = ret2 and func_val.callv([iswin,_turn_count,teamCode,teamCode2])
		return ret1 or ret2
		
	var func_t2 = func(iswin,_turn_count,teamCode,teamCode2):
		var ret1 = iswin
		var ret2 = not iswin
		for func_val in list:
			ret1 = ret1 and func_val.callv([iswin,_turn_count,teamCode,teamCode2])
		for func_val in list_enemy:
			ret2 = ret2 and func_val.callv([iswin,_turn_count,teamCode,teamCode2])

		return ret1 or ret2
	recorder.ResigerFunc(func_t1)
	recorder.ResigerFunc(func_t2)
	var ret = recorder.ReparseRoundData()
	recorder.Clear()
	
	var text = " 总场：" + str(ret[0]) + " 胜场：" + str(ret[1]) +  \
			" 胜率：" + "%.2f" % (float(ret[1]) / float(ret[0]) * 100) + "%\n"
			
	info_edit.clear()
	info_edit.text = text
	
