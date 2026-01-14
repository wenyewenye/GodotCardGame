extends Card

func Attack():
	var ratio = 0.05
	var attack_array = TrackMethod.GetNormal(enemy_board.cards,pos)
	var damage = ratio * self.stat.max_health + 1.0 * self.stat.base_attack
	for i in attack_array:
			self.DoAttack(enemy_board.cards[i].card,damage,Events.LOGLEVEL.ATTACK,"attack")
	GanaMana()

func SuperAttack():
	var ratio = -0.5
	var effect = EffectDamageReduction.new()
	effect.init(2,ratio,self)
	effect.Do(self)
	if effect.duration != 0:
		self.effect_list.append(effect)
	self.stat.max_health += self.stat.base_attack
	self.DoHeal(self, self.stat.base_attack * 2.0, Events.LOGLEVEL.SUPERATTACK)
	pass
