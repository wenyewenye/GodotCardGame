class_name  StatisticData

var damageMaking:int = 0
var damageTaking:int = 0
var healMaking:int = 0
var healTaking:int = 0
var blockUsed:int = 0
var kill:int = 0
var livingcount:int = 0

static func CountDamageMaking(src_card,dst_card,damage,type,damageTakingCallBack:Callable=Callable()): 
	var tmpHealth = dst_card.stat.health
	var tmpBlock = dst_card.stat.block
	damageTakingCallBack.call(src_card,damage,type)
		
	if dst_card.stat.islive == false:
		src_card.statisticData.damageMaking += tmpHealth + tmpBlock
		src_card.statisticData.kill += 1
		return
	if src_card == dst_card:
		return
	src_card.statisticData.damageMaking += damage
	
static func CountDamageTaking(src_card,dst_card,damage,_type,damageTakingCallBack:Callable=Callable()): 
	var tmpBlock = dst_card.stat.block
	var tmpHealth = dst_card.stat.health
	damageTakingCallBack.call(damage)
	
	dst_card.statisticData.blockUsed += tmpBlock - dst_card.stat.block
	if dst_card.stat.islive == false:
		dst_card.statisticData.damageTaking += tmpHealth
		return
		
	if src_card == dst_card:
		dst_card.statisticData.healMaking -= damage
		dst_card.statisticData.healTaking -= damage
		return
	dst_card.statisticData.damageTaking += damage
	
	
