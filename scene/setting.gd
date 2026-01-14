extends Control
@onready var grid_container: GridContainer = $TabContainer/GridContainer

@onready var button: Button = $Button

func _ready() -> void:
	var fastModeBox = CheckBox.new()
	fastModeBox.text = "快速模式"
	grid_container.add_child(fastModeBox)
	fastModeBox.button_pressed  = Global.isFastMode
	fastModeBox.toggled.connect(func(pressd) : Global.isFastMode = pressd)
	
	var debugModeBox = CheckBox.new()
	debugModeBox.text = "调试模式"
	grid_container.add_child(debugModeBox)
	debugModeBox.button_pressed  = Global.isDebug
	debugModeBox.toggled.connect(func(pressd) : Global.isDebug = pressd)
	
	var timeBoxContainer = HBoxContainer.new()
	var timeBoxText = Label.new()
	timeBoxText.text =  "运行批次"
	timeBoxContainer.add_child(timeBoxText)
	var timeBox =SpinBox.new()
	timeBoxContainer.add_child(timeBox)
	grid_container.add_child(timeBoxContainer)
	timeBox.max_value = Global.MAX_VALUE
	timeBox.value = Global.Times
	timeBox.value_changed.connect(func(change_value) : Global.Times = change_value)
	
	var teamSizeBoxContainer = HBoxContainer.new()
	var teamSizeBoxText = Label.new()
	teamSizeBoxText.text =  "队伍大小"
	teamSizeBoxContainer.add_child(teamSizeBoxText)
	var teamSizeBox =SpinBox.new()
	teamSizeBoxContainer.add_child(teamSizeBox)
	grid_container.add_child(teamSizeBoxContainer)
	teamSizeBox.max_value = Global.MAX_VALUE
	teamSizeBox.value = Global.team_size
	teamSizeBox.value_changed.connect(func(change_value) : Global.team_size = change_value)
	
	
	var typeSizeBoxContainer = HBoxContainer.new()
	var typeLineEdit = LineEdit.new()
	var typeText = Label.new()
	typeText.text = "游戏模式"
	typeSizeBoxContainer.add_child(typeText)
	typeSizeBoxContainer.add_child(typeLineEdit)
	grid_container.add_child(typeSizeBoxContainer)
	typeLineEdit.text = Global.type
	typeLineEdit.text_changed.connect(func(change_value) : Global.type = change_value)
	
	button.pressed.connect(self.quit)
	
	
func quit():
	# 创建新的 ConfigFile 对象。
	var config = ConfigFile.new() 
	

	# 存储一些值。
	config.set_value("Global", "isFastMode", Global.isFastMode)
	config.set_value("Global", "isDebug", Global.isDebug)
	config.set_value("Global", "Times", Global.Times)
	config.set_value("Global", "team_size", Global.team_size)
	config.set_value("Global", "type", Global.type)

	# 将其保存到文件中（如果已存在则覆盖）。
	config.save("res://Global.cfg")
	self.hide()
