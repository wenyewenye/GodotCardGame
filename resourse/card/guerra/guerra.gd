extends Card

func Attack():
	var ratio = 1 - float(self.stat.health)/self.stat.max_health
	#var type = Events.LOGLEVEL.ATTACK
	var damage:int = (0.9 + 0.6 * ratio) * self.stat.attack
		
	var attack_array = TrackMethod.GetNormal(enemy_board.cards,pos)
	for i in attack_array:
		self.DoAttack(enemy_board.cards[i].card,damage,Events.LOGLEVEL.ATTACK,"attack")
	#DoAttack(attack_array,damage,type)
	GanaMana()



func SuperAttack():

	var ratio = 1 - float(self.stat.health)/self.stat.max_health
	var type = Events.LOGLEVEL.SUPERATTACK
	var damage:int = (1.0 + 1.5 * ratio) * self.stat.attack
		
	var attack_array = TrackMethod.GetNormal(enemy_board.cards,pos)
	for i in attack_array:
		self.DoAttack(enemy_board.cards[i].card,damage,Events.LOGLEVEL.SUPERATTACK,"attack")
	self.DoHeal(self,damage * 1.3,Events.LOGLEVEL.SUPERATTACK)
	self.stat.attack += 30
	pass


func RefreshState():
	super.RefreshState()
	self.stat.attack = max(self.stat.base_attack, self.stat.attack - 5)
	
