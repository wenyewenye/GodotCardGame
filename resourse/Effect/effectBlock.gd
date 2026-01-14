extends  Effect
class_name EffectBlock

func init(dur,v,card):
	self.duration = dur
	self.value = v
	self.srcCard = card

func Do(_card):
	duration  -= 1
	pass
	
