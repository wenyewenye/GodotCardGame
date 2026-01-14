extends Effect
class_name EffectThorn

func _init() -> void:
	duration = 0
	effect_name = "Thorn"
	effect_name_zh = "反伤"
	value =0
	isGood = false
	pass

func init(dur,v,card):
	self.duration = dur
	self.value = v
	self.srcCard = card

func Do(card:Card):
	var  callback = func(card,enemy,damage,type): 
		if type == 'attack':
			var logText = "[thorn][{0}] 对 [{1}] Add了 {2} 伤害 ({3})".format([card.name,enemy.name,damage * value,effect_name])
			Events.setlog.emit(logText,Events.LOGLEVEL.LITE)
			card.MakeDamage(enemy,damage * value,"reverge")
	card.surfer_callback_list.append(callback)
	duration  -= 1
	pass

func Durate():
	duration  -= 1
