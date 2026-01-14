extends Card

func Attack():
	var poisn_value = self.stat.base_attack * 0.4
	var attack_array = TrackMethod.GetNormal(enemy_board.cards,pos)
	for i in attack_array:
		var effect = EffectPoison.new()
		effect.init(3,poisn_value,self)
		enemy_board.cards[i].card.effect_list.append(effect)
		for effect_t:Effect in enemy_board.cards[i].card.effect_list.effect_vector:
			if effect_t.effect_name == "Poison":
				effect_t.value *= 1.12
	GanaMana()


func SuperAttack():
	var poisn_value = self.stat.base_attack * 0.55
	var attack_array = TrackMethod.GetAll(enemy_board.cards)
	for i in attack_array:
		var effect = EffectPoison.new()
		effect.init(3,poisn_value,self)
		enemy_board.cards[i].card.effect_list.append(effect)
	pass
