extends Card


func Attack():
	var ratio = 0.9
	var attack_array = TrackMethod.GetNormal(enemy_board.cards,pos)
	var damage =ratio * self.stat.attack
	for i in attack_array:
		self.DoAttack(enemy_board.cards[i].card,damage,Events.LOGLEVEL.ATTACK,"attack")
	
	var block_ratio = 0.2
	var block_array = TrackMethod.GetLowPercentHP(board.cards, 3)
	AddBlock(block_array, self.stat.attack * block_ratio, 1,Events.LOGLEVEL.ATTACK)
	for i in block_array:
		board.cards[i].card.TakeBlock(self,board.cards[i].card.stat.block * 0.3)
	GanaMana()


func SuperAttack():
	var ratio = 1.2
	var block_array = TrackMethod.GetAll(board.cards)
	AddBlock(block_array,ratio * self.stat.base_attack, 2,Events.LOGLEVEL.SUPERATTACK)
	pass
