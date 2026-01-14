extends Card

func TakeDamage(enemy,damage,type):
	for callback_func in surfer_callback_list:
		callback_func.callv([self,enemy,damage,type])
	super.TakeDamage(enemy,damage,type)
	if type == "attack":
		var poisn_value = self.stat.base_attack * 0.25
		var effect = EffectPoison.new()
		effect.init(1,poisn_value,self)
		enemy.effect_list.append(effect)

func Attack():
	var attack_array = TrackMethod.GetNormal(enemy_board.cards,pos)
	if attack_array.size() != 1:
		return
	var DebuffCount = enemy_board.cards[attack_array[0]].card.effect_list.GetBuffAmount()[1]
	var damage = self.stat.base_attack + self.stat.max_health * 0.02 * DebuffCount
	for i in attack_array:
		self.DoAttack(enemy_board.cards[i].card,damage,Events.LOGLEVEL.ATTACK,"attack")
	GanaMana()

func SuperAttack():
	var heal_value = self.stat.max_health * 0.40
	DoHeal(self,heal_value,Events.LOGLEVEL.SUPERATTACK)
	var poisn_value = self.stat.max_health * 0.08
	var effect = EffectPoison.new()
	effect.init(3,poisn_value,self)
	self.effect_list.append(effect)
	pass
