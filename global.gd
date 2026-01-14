extends Node

var isDebug = true
var isFastMode = true
var MAX_VALUE = 0xffff
var MAX_CARDNUM = 17
var Times = 300
var SAVE_PATH = "./temp/demo.csv"
var team_size:int = 6
var type:String = 'round'
var MAX_WIN_COUNT = 12

func _ready() -> void:
	var config = ConfigFile.new()
	# 从文件加载数据。
	var err = config.load("res://Global.cfg")
	# 如果文件没有加载，忽略它。
	if err != OK:
		return

	# 获取每个小节的数据。

	Global.isFastMode = config.get_value("Global", "isFastMode")
	Global.isDebug = config.get_value("Global", "isDebug")
	Global.Times = config.get_value("Global", "Times")
	Global.team_size = config.get_value("Global", "team_size")
	Global.type = config.get_value("Global", "type")
	
