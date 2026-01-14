# GlobalUI.gd
extends Node
@onready var card_repo: GridContainer

# 对 CanvasLayer 的引用
var _canvas_layer: CanvasLayer
var _grid: GridContainer 
var _centre_container: CenterContainer 
func _ready():
	# 创建并配置 CanvasLayer
	_canvas_layer = CanvasLayer.new()
	_canvas_layer.layer = 128  # 设置一个非常高的层级，确保在最前
	add_child(_canvas_layer) # 将CanvasLayer添加为单例的子节点
	_centre_container = CenterContainer.new()
	_centre_container.size = get_viewport().get_visible_rect().size
	_centre_container.hide()
	

# 公共方法：在任何地方调用此函数生成最上层Label
func show_top_label(text: String, duration: float = 3.0) -> void:
	var label = Label.new()
	label.text = text
	label.modulate = Color.WHITE # 初始颜色

	# --- 样式设置（可根据需要调整）---
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	# 添加一个样式盒背景使其更清晰
	var style_box = StyleBoxFlat.new()
	style_box.bg_color = Color(0, 0, 0, 0.7) # 半透明黑色背景
	style_box.set_corner_radius_all(5)

	label.add_theme_stylebox_override("normal", style_box)
	# 添加一些内边距
	label.add_theme_constant_override("outline_size", 16)
	# ------------------------------

	# 将Label添加到CanvasLayer，而不是当前场景
	_canvas_layer.add_child(label)

	# 设置初始位置（例如屏幕顶部中央）
	label.size = Vector2(200, 50) # 预设一个大小，或者用minimum_size
	label.position = Vector2(
		(get_viewport().get_visible_rect().size.x - label.size.x) / 2,
		50 # 距离顶部50像素
	)

	# 可选：添加一个向上漂浮并淡出的动画
	var tween = create_tween().set_parallel(true) # 并行动画
	tween.tween_property(label, "position:y", label.position.y - 50, duration) # 上浮
	tween.tween_property(label, "modulate:a", 0.0, duration) # 淡出

	# 动画结束后，删除Label以释放资源
	tween.tween_callback(label.queue_free).set_delay(duration)

func RegisterCardRepo(input_card_repo):
	card_repo = input_card_repo
	
func show_card_select_view(_global_pos):
	if card_repo == null:
		return
	if 	_grid != null:
		_grid.queue_free()
	_grid = GridContainer.new()
	
	_grid.set_columns(5)
	var card_array = range(Global.MAX_CARDNUM)
	card_array = card_repo.GetCardArry(card_array)
	for i in card_array.size() - 1:
		var card_ui:CardUI = card_array[i+1]
		var button:ClickButton = ClickButton.new()
		button.texture_normal = card_ui.pic.texture
		button.index = i + 1
		button.stretch_mode = TextureButton.STRETCH_SCALE
		button.custom_minimum_size = Vector2(32 *3, 48 * 3)
		_grid.add_child(button)
	_centre_container.add_child(_grid)
	_canvas_layer.add_child(_centre_container)
	

func GetCardSelectArray():
	var ret = []
	if _grid == null:
		return ret
	for card:ClickButton in _grid.get_children():
		if card.flag == 1:
			ret.append(card.index)
	return ret

func GetCardExcludeArray():
	var ret = [] 
	if _grid == null:
		return ret
	for card:ClickButton in _grid.get_children():
		if card.flag == 2:
			ret.append(card.index)
	return ret
