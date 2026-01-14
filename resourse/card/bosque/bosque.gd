extends Card
var RecordDamage = 0

func SuperAttack():
	var ratio = 0.15
	var heal_value = RecordDamage * ratio + self.stat.base_attack * 1.0
	self.DoHeal(self,heal_value,Events.LOGLEVEL.SUPERATTACK)
	RecordDamage = 0
	pass

func TakeDamage(enemy,damage,type):
	for callback_func in surfer_callback_list:
		callback_func.callv([self,enemy,damage,type])
	RecordDamage += damage
	super.TakeDamage(enemy,damage,type)


func TakeHeal(card,heal_value):
	heal_value *= 1.12
	super.TakeHeal(card,heal_value)
	

func RefreshState():
	super.RefreshState()
	var ratio = 0.10
	var heal_value = ratio * (self.stat.max_health - self.stat.health)
	self.DoHeal(self, heal_value,Events.LOGLEVEL.LITE)
