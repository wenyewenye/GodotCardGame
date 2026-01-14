extends RefCounted
class_name EffectList


var effect_vector:Array[Effect] = []

func Refresh():
	effect_vector = effect_vector.filter(func(effect): return effect.duration != 0)
	
func append(effect:Effect):
	effect_vector.append(effect)

func GetPoisonAmount():
	var amount = 0
	for effect in effect_vector:
		if effect.effect_name == "Poison":
			amount += effect.value
	return amount

func GetBuffAmount():
	var ret = [0,0]
	for effect in effect_vector:
		if effect.isGood == true:
			ret[0] += 1
		else:
			ret[1] += 1
	return ret

func AddBleed(effect_bleed:EffectBleed):
	for effect in effect_vector:
		if effect.effect_name == "Bleed":
			effect.value += effect_bleed.value
			return
	effect_vector.append(effect_bleed)

func HaveEffect(effect_name)->bool:
	for effect in effect_vector:
		if effect.effect_name == effect_name:
			return true
	return false

func GetEffect(effect_name)->Effect:
	for effect in effect_vector:
		if effect.effect_name == effect_name:
			return effect
	return null
