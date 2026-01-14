extends Effect
class_name EffectDamageAumnet

func _init() -> void:
	duration = 0
	effect_name = "DamageAument"
	effect_name_zh = "伤害"
	value = 0
	isGood = true
	pass

func init(dur,v,card):
	self.duration = dur
	self.value = v
	if v >= 0: 
		effect_name_zh = "造成伤害增加"
		isGood = true
	else:
		effect_name_zh = "造成伤害减少"
		isGood = false
		
	self.srcCard = card

func Do(card:Card):
	var logText = "[effect][{0}] 对 [{1}] Add了 {2}% 伤害加成 ({3})".format([self.srcCard.name,card.name,value * 100,effect_name])
	Events.setlog.emit(logText,Events.LOGLEVEL.LITE)
	card.stat.damage_increase = clampf(card.stat.damage_increase + value , 0 , Global.MAX_VALUE)
	duration  -= 1
	pass
