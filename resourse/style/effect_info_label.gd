# ins_label.gd
extends Label
class_name InsLabel

@export var corner_radius: int = 12:
	set(value):
		corner_radius = value
		update_background()

@export var border_width: int = 1:
	set(value):
		border_width = value
		update_background()

@export var shadow_size: int = 4:
	set(value):
		shadow_size = value
		update_background()

@export var shadow_color: Color = Color(0, 0, 0, 0.1):
	set(value):
		shadow_color = value
		update_background()

@export var bg_color: Color = Color.WHITE:
	set(value):
		bg_color = value
		update_background()

@export var border_color: Color = Color(0.9, 0.9, 0.9):
	set(value):
		border_color = value
		update_background()

@export var text_color: Color = Color(0.2, 0.2, 0.2):
	set(value):
		text_color = value
		update_font_color()

func _ready():
	setup_style()
	setup_font()

func setup_style():
	# 创建背景样式
	var style = StyleBoxFlat.new()
	style.bg_color = bg_color
	style.border_color = border_color
	style.set_border_width_all(border_width)
	style.set_corner_radius_all(corner_radius)
	
	# 阴影效果
	style.shadow_color = shadow_color
	style.shadow_size = shadow_size
	style.shadow_offset = Vector2(0, 2)
	
	# 应用样式
	add_theme_stylebox_override("normal", style)

func setup_font():
	# 设置字体颜色
	add_theme_color_override("font_color", text_color)
	
	# 设置字体大小，INS风格通常使用较细的字体
	add_theme_font_size_override("font_size", 14)
	
	# 文字居中对齐
	horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vertical_alignment = VERTICAL_ALIGNMENT_CENTER

func update_background():
	if not is_inside_tree():
		return
	setup_style()

func update_font_color():
	if not is_inside_tree():
		return
	add_theme_color_override("font_color", text_color)

# 预设风格切换
func set_style(preset: String):
	match preset:
		"light":
			bg_color = Color.WHITE
			border_color = Color(0.9, 0.9, 0.9)
			text_color = Color(0.2, 0.2, 0.2)
			shadow_color = Color(0, 0, 0, 0.1)
		"dark":
			bg_color = Color(0.1, 0.1, 0.1)
			border_color = Color(0.2, 0.2, 0.2)
			text_color = Color(0.9, 0.9, 0.9)
			shadow_color = Color(0, 0, 0, 0.3)
		"card":
			bg_color = Color(0.98, 0.98, 0.98)
			border_color = Color(0.85, 0.85, 0.85)
			text_color = Color(0.3, 0.3, 0.3)
			corner_radius = 16
			shadow_size = 6
	
	update_background()
	update_font_color()
