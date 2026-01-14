extends Card
var green_count = 1

func Attack():
	var ratio = 1.0
	var attack_array = TrackMethod.GetNormal(enemy_board.cards,pos)
	var damage = ratio * self.stat.base_attack
	for i in attack_array:
		self.DoAttack(enemy_board.cards[i].card,damage,Events.LOGLEVEL.ATTACK,"attack")
	GanaMana()
	var heal_ratio = 0.5 * (1.0 - float(stat.health) / float(stat.max_health))
	var heal_value = heal_ratio * damage
	self.DoHeal(self,heal_value,Events.LOGLEVEL.ATTACK)


func SuperAttack():
	var ratio = 0.4
	var attack_array = TrackMethod.GetAll(enemy_board.cards)
	var damage = ratio * self.stat.base_attack
	for i in attack_array:
		self.DoAttack(enemy_board.cards[i].card,damage,Events.LOGLEVEL.SUPERATTACK,"attack")
	self.DoHeal(self,attack_array.size() * damage,Events.LOGLEVEL.SUPERATTACK)


func TakeDamage(enemy,damage,type):
	super.TakeDamage(enemy,damage,type)
	if stat.health <= stat.max_health * 0.25 and green_count != 0:
		green_count -= 1
		SuperAttack()
