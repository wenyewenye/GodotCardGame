extends Card

func CalculateBlock():
	stat.block = 0
	var tmpBlock:int = 0
	for effect in block_list:
		effect.Do(self)
		if effect.duration != 0:
			tmpBlock += effect.value
	block_list = block_list.filter(func(effect): return effect.duration != 0)
	stat.block = min(stat.block, tmpBlock + self.stat.base_attack * 3)

func Attack():
	var ratio = 1.0
	var attack_array = TrackMethod.GetNormal(enemy_board.cards,pos)
	var damage = ratio * self.stat.base_attack
	for i in attack_array:
		self.DoAttack(enemy_board.cards[i].card, damage, Events.LOGLEVEL.ATTACK,"attack")
	var block_ratio = 0.35
	AddBlock([pos],block_ratio * self.stat.base_attack,1,Events.LOGLEVEL.ATTACK)
	GanaMana()



func SuperAttack():
	var ratio = 0.8
	var block_ratio = 0.35
	var attack_array = TrackMethod.GetNormal(enemy_board.cards,pos)
	if attack_array.is_empty():
		return
	for _i in range(3):
		if  not enemy_board.cards[attack_array[0]].card.stat.islive:
			break
		for i in attack_array:
			self.DoAttack(enemy_board.cards[i].card,ratio * self.stat.base_attack,Events.LOGLEVEL.SUPERATTACK,"attack")
		AddBlock([pos],block_ratio * self.stat.base_attack,1,Events.LOGLEVEL.SUPERATTACK)

	pass
