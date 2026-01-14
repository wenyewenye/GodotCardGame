extends Card
var heat = 0

func Attack():
	var ratio = 1.0 + heat * 0.08
	var damage = ratio * self.stat.base_attack
	var attack_array = TrackMethod.GetNormal(enemy_board.cards,pos)
	if heat >= 5:
		attack_array = TrackMethod.GetLowHP(enemy_board.cards)
	for i in attack_array:
		self.DoAttack(enemy_board.cards[i].card,damage,Events.LOGLEVEL.ATTACK,"attack")
	#DoAttack(attack_array,damage,Events.LOGLEVEL.ATTACK)
	GanaMana()

func SuperAttack():
	var ratio = 1.0 + heat * 0.2
	var attack_array = TrackMethod.GetLowHP(enemy_board.cards)
	for i in attack_array:
		self.DoAttack(enemy_board.cards[i].card,ratio * self.stat.base_attack,Events.LOGLEVEL.SUPERATTACK,"attack")
		if  enemy_board.cards[i].card.stat.islive == false:
			SuperAttack()
	pass


func DoAttack(arr,damage,level,type):
	if heat < 8:
		heat += 1
	super.DoAttack(arr,damage,level,type)
