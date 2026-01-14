extends Card


func _init() -> void:
	super._init()


func Attack():
	var ratio = 1.0
	var attack_array = TrackMethod.GetNormal(enemy_board.cards,pos)
	var effect = EffectDamageAumnet.new()
	
	for i in attack_array:
		self.DoAttack(enemy_board.cards[i].card,ratio * self.stat.base_attack,Events.LOGLEVEL.ATTACK,"attack")
		effect.init(1,-0.1,self)
		enemy_board.cards[attack_array[0]].card.effect_list.append(effect)
	GanaMana()
	
	var heal_ratio = 0.3
	var heal_array = TrackMethod.GetLowHP(board.cards,true)
	for i in heal_array:
		DoHeal(board.cards[i].card,heal_ratio * self.stat.base_attack,Events.LOGLEVEL.ATTACK)


func SuperAttack():
	var ratio = 0.7
	var heal_array = TrackMethod.GetAll(board.cards)
	for i in heal_array:
		DoHeal(board.cards[i].card,ratio * self.stat.base_attack,Events.LOGLEVEL.SUPERATTACK)
	pass
