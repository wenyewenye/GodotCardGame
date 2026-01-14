extends Effect
class_name EffectPoison

func _init() -> void:
	duration = 0
	effect_name = "Poison"
	effect_name_zh = "中毒"
	value =0
	isGood = false
	pass

func init(dur,v,card):
	self.duration = dur
	self.value = v
	self.srcCard = card

func Do(card:Card):
	var logText = "[effect][{0}] 对 [{1}] Add了 {2} 伤害 ({3})".format([self.srcCard.name,card.name,value,effect_name])
	Events.setlog.emit(logText,Events.LOGLEVEL.LITE)
	self.srcCard.MakeDamage(card,value,"dot")
	duration  -= 1
	pass

func Durate():
	duration  -= 1
