class_name CardUI
extends Control
@warning_ignore("unused_signal")
signal reparent_requested(which_card_ui: CardUI)
signal active_requested(which_card_ui: CardUI)
signal deactive_requested(which_card_ui: CardUI)
@export var card:Card
@export var style:StyleBox


@onready var card_panel: Panel = $CardPanel
@onready var pic: TextureRect = $Pic
@onready var drop_point_detector: Area2D = $DropPointDetector
@onready var card_state_machine: CardStateMachine = $CardStateMachine
var tween:Tween
var active_pos := -1
var isfocus := false
var board:Node = null
static var card_board:Node = null
static var enemy_board:Node = null
var isGray := false

func _ready() -> void:
	card_state_machine.init(self)
	card_board = get_tree().get_nodes_in_group("Board")[0]
	enemy_board = get_tree().get_nodes_in_group("EnemyBoard")[0]
	
	if style != null:
		card_panel.add_theme_stylebox_override("panel",style)
	pic.texture = card.img
	#img.get_height()


func _input(event: InputEvent) -> void:
	card_state_machine.on_input(event)

func _on_gui_input(event: InputEvent) -> void:
	card_state_machine.on_gui_input(event)


func _on_mouse_entered() -> void:
	isfocus = true
	card_state_machine.on_mouse_entered()


func _on_mouse_exited() -> void:
	isfocus = false
	card_state_machine.on_mouse_exited()


func _on_drop_point_detector_area_entered(area: Area2D) -> void:
	if board == null:
		board = area.get_parent()
		self.active_requested.connect(board._on_active_signl)
		self.deactive_requested.connect(board._on_deactive_signl)
	pass # Replace with function body.


func _on_drop_point_detector_area_exited(_area: Area2D) -> void:
	if board != null:
		if self.active_requested.is_connected(board._on_active_signl):
			self.active_requested.disconnect(board._on_active_signl)
		if self.active_requested.is_connected(board._on_deactive_signl):
			self.deactive_requested.disconnect(board._on_deactive_signl)
		board = null
	pass # Replace with function body.

func FirstAction():
	card.FirstAction()

func Action():
	card.Action();


func Animate(card,board):
	if Global.isFastMode:
		return true
	
	var i = card.pos
	var cardSize = board.cards[i].size
	var srcPos = self.global_position
	var dstPos = board.cards[i].global_position

	var line = Line2D.new()
	line.width = 5
	line.default_color = Color(1, 0, 0) # 红色
	line.add_point(srcPos - self.global_position + cardSize/2)
	line.add_point(dstPos - self.global_position + cardSize/2)
	line.modulate = Color(1, 0, 0, 0.5) # 红色
	
	var rect = ColorRect.new()
	rect.color = Color(0, 0, 1)
	rect.size = Vector2(20,20)
	rect.position = cardSize/2 - rect.size/2
	
	
	if board == self.board:
		line.modulate = Color(0, 1, 0, 1) 
		line.default_color = Color(0, 1, 0) 
	add_child(line)
	add_child(rect)
	await  get_tree().create_timer(0.5).timeout
	line.queue_free()
	rect.queue_free()

func _on_animate(arr,board_input):
	Animate(arr,board_input)

func _on_death():
	self.queue_free()
	
func Copy()->CardUI:
	var cardUI:CardUI = self.duplicate()
	cardUI.pic = pic
	cardUI.card = card.Copy()
	cardUI.board = self.board
	cardUI.InitCardTeam()
	cardUI.card.animate.connect(cardUI._on_animate)
	cardUI.card.stat.death.connect(cardUI.TurnGray)
	cardUI.drop_point_detector = drop_point_detector.duplicate()
	return cardUI

func isLive():
	return self.card.stat.islive

func TurnGray():
	if isGray:
		return
	self.pic.texture = GetGrayImg()
	isGray = true

func GetGrayImg():
	var img = self.pic.texture.get_image()
	for x in range(img.get_width()):
		for y in range(img.get_height()):
			var old_pixel = img.get_pixel(x,y)
			var gray = (old_pixel.r + old_pixel.g + old_pixel.b)/3
			var color = Color(gray, gray, gray, old_pixel.a)
			img.set_pixel(x, y, color)
	return ImageTexture.create_from_image(img)
	

func InitCardTeam():
	if board == null:
		return
	if card_board == board:
		self.card.board = card_board
		self.card.enemy_board = enemy_board
	else:
		self.card.board = enemy_board
		self.card.enemy_board = card_board
