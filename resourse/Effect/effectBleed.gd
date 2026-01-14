extends Effect
class_name EffectBleed

func _init() -> void:
	duration = 0
	effect_name = "Bleed"
	effect_name_zh = "流血"
	value = 0
	isGood = false
	pass

func init(dur,v,card):
	self.duration = dur
	self.value = v
	self.srcCard = card

func Do(card:Card):
	if self.value <= 1:
		duration = 0
	var damage = value / 2
	value = value - damage
	var logText = "[effect][{0}] 对 [{1}] Add了 {2} 伤害 ({3})".format([self.srcCard.name,card.name,damage,effect_name])
	Events.setlog.emit(logText,Events.LOGLEVEL.LITE)
	self.srcCard.MakeDamage(card,damage,"dot")
	pass

func Durate():
	duration  -= 1
