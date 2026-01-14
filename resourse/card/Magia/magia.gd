extends Card
var layer := 0
var THRESHLD := 18

func Attack():
	var ratio = [0.9, 0.42]
	
	var attack_array = TrackMethod.GetCol(enemy_board.cards,pos)
	#if attack_array.size() == 2: damage = self.stat.base_attack * 0.68
	for i in range(attack_array.size()):
		var damage = self.stat.base_attack * ratio[i]
		self.DoAttack(enemy_board.cards[attack_array[i]].card,damage,Events.LOGLEVEL.ATTACK,"attack")

	GanaMana()
	layer += attack_array.size()
	if layer >= THRESHLD:
		layer -= THRESHLD
		self.stat.mana += 100


func SuperAttack():
	var attack_array = TrackMethod.GetAll(enemy_board.cards)
	var damage = self.stat.base_attack * (1.4 + 0.12 * (6 - attack_array.size()))
	for i in attack_array:
		self.DoAttack(enemy_board.cards[i].card,damage,Events.LOGLEVEL.SUPERATTACK,"attack")
	layer += attack_array.size()
	pass
