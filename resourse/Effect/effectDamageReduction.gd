extends Effect
class_name EffectDamageReduction

func _init() -> void:
	duration = 0
	effect_name = "DamageReduction"
	effect_name_zh = "承伤"
	value = 0
	isGood = true
	pass

func init(dur,v,card):
	self.duration = dur
	self.value = v
	if v >= 0: 
		effect_name_zh = "收到伤害增加"
		isGood = false
	else:
		effect_name_zh = "收到伤害减少"
		isGood = true
		
	self.srcCard = card

func Do(card:Card):
	var logText = "[effect][{0}] 对 [{1}] Add了 {2}% 伤害减免 ({3})".format([self.srcCard.name,card.name,value * 100,effect_name])
	Events.setlog.emit(logText,Events.LOGLEVEL.LITE)
	card.stat.damage_reduction = clampf(card.stat.damage_reduction + value , 0 , Global.MAX_VALUE)
	duration  -= 1
	pass
