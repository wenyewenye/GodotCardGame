extends Card

func Attack():
	var bleed_value = self.stat.base_attack * 0.25
	var attack_array = TrackMethod.GetLowHP(enemy_board.cards)
	for i in attack_array:
		var effect = EffectBleed.new()
		effect.init(1,bleed_value,self)
		enemy_board.cards[i].card.effect_list.AddBleed(effect)
		self.DoAttack(enemy_board.cards[i].card,self.stat.base_attack * 0.9,Events.LOGLEVEL.ATTACK,"attack")
		
	GanaMana()


func SuperAttack():
	var attack_array = TrackMethod.GetLowHP(enemy_board.cards)
	var damage = self.stat.base_attack * 1.5

	for i in attack_array:
		if enemy_board.cards[i].card.effect_list.HaveEffect("Bleed"):
			var bleedEffect = enemy_board.cards[i].card.effect_list.GetEffect("Bleed")
			damage += bleedEffect.value
			stat.mana += 60
		self.DoAttack(enemy_board.cards[i].card,damage,Events.LOGLEVEL.SUPERATTACK,"attack")
		
		var effect = EffectBleed.new()
		var bleed_value = self.stat.base_attack * 0.6
		effect.init(1,bleed_value,self)
		enemy_board.cards[i].card.effect_list.AddBleed(effect)
	pass
