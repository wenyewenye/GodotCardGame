extends Card
var flecha_num:int = 2
var super_additional_damage = 0
var additional_damage = 0
var log_type = Events.LOGLEVEL.ATTACK

func Attack():
	var ratio = 1.1
	var damage:int = ratio * self.stat.base_attack / flecha_num + super_additional_damage
	var multi_hit_buff = 1.0
	for _i in range(flecha_num):
		var attack_array = TrackMethod.GetNormal(enemy_board.cards,pos)
		multi_hit_buff += 0.10
		for i in attack_array:
			self.DoAttack(enemy_board.cards[i].card,multi_hit_buff * damage,log_type,"attack")
		GanaMana()

func GanaMana():
	self.stat.mana += 10

func SuperAttack():
	if flecha_num < 10:
		flecha_num += 1
	stat.additional_damage = 0.24 * self.stat.base_attack
	log_type = Events.LOGLEVEL.SUPERATTACK
	Attack()
	log_type = Events.LOGLEVEL.ATTACK
	pass
