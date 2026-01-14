extends Card

func Attack():
	var ratio = 1.0
	var attack_array = TrackMethod.GetNormal(enemy_board.cards,pos)
	var damage = ratio * self.stat.base_attack 
	if !attack_array.is_empty():
		ratio = 0.5
		damage += ratio * enemy_board.cards[attack_array[0]].card.effect_list.GetPoisonAmount()
	for i in attack_array:
		self.DoAttack(enemy_board.cards[i].card,damage,Events.LOGLEVEL.ATTACK,"attack")
	GanaMana()


func SuperAttack():
	var poisn_value = self.stat.base_attack * 0.7
	var attack_array = TrackMethod.GetNormal(enemy_board.cards,pos)
	for i in attack_array:
		var effect = EffectPoison.new()
		effect.init(4,poisn_value,self)
		enemy_board.cards[i].card.effect_list.append(effect)
	pass

func GetPoisonAmount(effect_list:Array[Effect]):
	var amount = 0
	for effect in effect_list:
		if effect.effect_name == "Poison":
			amount += effect.value
	return amount
