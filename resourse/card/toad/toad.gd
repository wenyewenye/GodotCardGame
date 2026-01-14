extends Card

func FirstAction():
	stat.damage_reduction = 0.85
	pass
func RefreshState():
	stat.additional_damage = 0
	stat.damage_increase = 1.0
	stat.damage_reduction = 0.85
	
func CalculateBlock():
	super.CalculateBlock()
	var ret = self.effect_list.GetBuffAmount()
	self.stat.block += ret[1] * 0.02 * self.stat.max_health


func SuperAttack():
	var level = Events.LOGLEVEL.SUPERATTACK
	var attack_array = TrackMethod.GetLowPercentHP(board.cards)
	AddBlock(attack_array, self.stat.base_attack * 2.0, 2,level)
	for effect in self.effect_list.effect_vector:
		if effect.isGood == false:
			effect_list.effect_vector.erase(effect)
			self.DoHeal(self, self.stat.max_health * 0.1,level)
	pass
