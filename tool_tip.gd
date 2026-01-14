extends PanelContainer
class_name ToolTip

@export var fade_seconds = 0.2

@onready var texture_rect: TextureRect = %TextureRect
@onready var rich_text_label: RichTextLabel = %RichTextLabel

var tween:Tween

func _ready() -> void:
	Events.card_tip_show.connect(show_tooltip)
	#Events.card_tip_hide.connect(hide_tooltip)
	modulate = Color.TRANSPARENT
	rich_text_label.bbcode_enabled = true
	rich_text_label.meta_clicked.connect(show_info)
	
	hide()
	
func show_tooltip(icon:Texture,card:Card)->void:
	if tween:
		tween.kill()
	texture_rect.texture = icon
	
	rich_text_label.text = ""
	var stat = card.stat
	var tmpBlock:int = 0
	for effect in card.block_list:
		tmpBlock += effect.value
	var test = "生命:{0}\n法力：{1}\n护盾:{2}({3})\n状态栏:".format([stat.health,stat.mana,stat.block,tmpBlock])
	
	rich_text_label.append_text(test)
	show_buff(card)
	tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_callback(show)
	tween.tween_property(self,"modulate",Color.WHITE,fade_seconds)
	
func hide_tooltip()->void:
	if tween:
		tween.kill()
	tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_callback(show)
	tween.tween_property(self,"modulate",Color.TRANSPARENT,fade_seconds)

func show_buff(card):
	var buff_set:Dictionary 
	buff_set = {
	#"Poison": "🤢",
	"Poison": " [img=24x24 middle]res://resourse/icon/poison.png[/img]",
	"DamageReduction":" [img=24x24 middle]res://resourse/icon/DamageReduction.png[/img]",
	"DamageAument":" [img=24x24 middle]res://resourse/icon/DamageAument.png[/img]",
	"Bleed":" [img=24x24 middle]res://resourse/icon/bleed.png[/img]",
	"Thorn":" [img=24x24 middle]res://resourse/icon/thorn.png[/img]"
	}

	for effect in card.effect_list.effect_vector:
		#buff_set[effect.effect_name] = effect
		##test += effect.effect_name_zh
	#for buff in buff_set.keys():
		rich_text_label.push_meta(effect,0)
		rich_text_label.append_text(buff_set[effect.effect_name])
		rich_text_label.pop()
		rich_text_label.append_text(' ')
		
func show_poison():
	pass

func show_info(meta):
	match meta.effect_name:
		"Poison":
			newLabel("中毒 {dur} * {val}".format({"dur": meta.duration, "val": int(meta.value)}))
		"DamageReduction":
			newLabel("承伤  {val}% * {dur}".format({"dur": meta.duration + 1, "val": meta.value * 100}))
		"DamageAument":
			newLabel("伤害  {val}% * {dur}".format({"dur": meta.duration, "val": meta.value * 100}))
		"Bleed":
			newLabel("流血  {val}".format({"val": meta.value}))
			pass

func newLabel(str):
	var label = Label.new()
	label.text = str
	var style_box = StyleBoxFlat.new()
	style_box.bg_color = Color(0, 0, 0, 0.7) # 半透明黑色背景
	style_box.set_corner_radius_all(5)
	label.add_theme_stylebox_override("normal", style_box)

	self.add_child(label)
	label.position = get_global_mouse_position() - rich_text_label.global_position
	rich_text_label.meta_hover_ended.connect(
		func (_meta):
			if label != null:
				label.queue_free())
