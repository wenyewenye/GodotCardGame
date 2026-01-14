
extends Card
var RecordDamage = 0

func SuperAttack():
	var ratio = 1.0
	var block_value = self.stat.base_attack * ratio
	AddBlock([pos], block_value, 2,Events.LOGLEVEL.SUPERATTACK)
	
	var effect = EffectThorn.new()
	effect.init(3,0.5,self)
	effect.Do(self)
	self.effect_list.append(effect)
	pass

func TakeDamage(enemy,damage,type):
	for callback_func in surfer_callback_list:
		callback_func.callv([self,enemy,damage,type])
	
	if type == "attack":
		damage -= self.stat.max_health * 0.012
		var logText = "[{0}] 缓和了 {1} 伤害".format([self.name,self.stat.max_health * 0.02])
		Events.setlog.emit(logText,Events.LOGLEVEL.RESPONSE)
	StatisticData.CountDamageTaking(enemy,self,damage,type,self.stat.take_damage)
