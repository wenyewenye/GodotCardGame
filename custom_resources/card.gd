class_name Card
extends Resource

enum Race {HUMAN, ELF}

@export_group("Card Attributes")
@export var index : int
@export var name : String
@export var prefer : String
@export var race : Race
@export var baseStat : Stat
@export var img: Texture2D
var stat : Stat
var board:Node = null
var enemy_board:Node = null
var pos = 0

var statisticData:StatisticData = StatisticData.new()
signal animate(arr:Array[int],board:Node)
var effect_list:EffectList
var block_list:Array[Effect]
var surfer_callback_list:Array = []




func _init():
	if baseStat != null:
		stat = baseStat
	else:
		stat = Stat.new()
	effect_list = EffectList.new()

func AfterAction():
	stat.damage_increase = 1.0
	pass

func FirstAction():
	pass
	
func Action():
	if self.stat.islive == false:
		return
	Events.setlog.emit('',Events.LOGLEVEL.TURN)
	BeforeAction()
	if not CanAction():
		return
	if self.stat.mana >= stat.skill_mana:
		self.stat.mana -= stat.skill_mana
		SuperAttack()
	else:
		Attack()
	pass
	
func BeforeAction():
	RefreshState()
	CalculateBlock()
	DealEffect()
	
func RefreshState():
	stat.additional_damage = 0
	stat.damage_reduction = 1.0
	surfer_callback_list.clear()

func CalculateBlock():
	var tmpBlock:int = 0
	for effect in block_list:
		effect.Do(self)
		if effect.duration != 0:
			tmpBlock += effect.value
	block_list = block_list.filter(func(effect): return effect.duration != 0)
	stat.block = min(stat.block, tmpBlock)
	
func Attack():
	var ratio = 1.0
	var attack_array = TrackMethod.GetNormal(enemy_board.cards,pos)
	
	for i in attack_array:
		self.DoAttack(enemy_board.cards[i].card,ratio * self.stat.attack,Events.LOGLEVEL.ATTACK,"attack")
	GanaMana()

func DoAttack(card,damage:int,level,type):
	if not Global.isFastMode:
		self.animate.emit(card,enemy_board)
	if type == "attack":
		damage += self.stat.additional_damage
	damage = damage * self.stat.damage_increase
	var damage_real = damage * card.stat.damage_reduction
	var logText = "[{0}] 对 [{1}] 造成了 {2} 伤害".format([self.name,card.name,damage_real])
	if level == Events.LOGLEVEL.SUPERATTACK:
		logText = "%super%" + logText
	Events.setlog.emit(logText,level)
	MakeDamage(card,damage_real,"attack")

func MakeDamage(enemy,damage,type):
	StatisticData.CountDamageMaking(self,enemy,damage,type,enemy.TakeDamage)

func TakeDamage(enemy,damage,type):
	for callback_func in surfer_callback_list:
		callback_func.callv([self,enemy,damage,type])
	StatisticData.CountDamageTaking(enemy,self,damage,type,self.stat.take_damage)
		
func DoHeal(card,heal_value,level):
	if not Global.isFastMode:
		self.animate.emit(card,board)
	var logText = "[{0}] 对 [{1}] 回复了 {2} HP".format([self.name,card.name,heal_value])
	if level == Events.LOGLEVEL.SUPERATTACK:
		logText = "%super%" + logText
	Events.setlog.emit(logText,level)
	MakeHeal(card,heal_value)

func SuperAttack():
	var ratio = 1.5
	var attack_array = TrackMethod.GetNormal(enemy_board.cards,pos)
	for i in attack_array:
		self.DoAttack(enemy_board.cards[i].card,ratio * self.stat.base_attack,Events.LOGLEVEL.SUPERATTACK,"attack")

func MakeHeal(card,heal_value):
	statisticData.healMaking += heal_value
	card.TakeHeal(self,heal_value)

func TakeHeal(_card,heal_value):
	statisticData.healTaking += heal_value
	self.stat.heal(heal_value)
	
func AddBlock(arr,block_value,duration,level):
	for i in arr:
		var logText = "[{0}] 对 [{1}] Add了 {2} Block".format([self.name,board.cards[i].card.name,block_value])
		if level == Events.LOGLEVEL.SUPERATTACK:
			logText = "%super%" + logText
		Events.setlog.emit(logText,level)
		MakeBlock(board.cards[i].card,block_value,duration)
		

func MakeBlock(card,block_value,duration):
	card.TakeBlock(self,block_value)
	var block_effect = EffectBlock.new()
	block_effect.init(duration,block_value,self)
	card.block_list.append(block_effect)

func TakeBlock(_card,block_value):
	self.stat.set_block(block_value + self.stat.block)


func Copy():
	var card:Card = self.duplicate()
	card.baseStat = self.baseStat.duplicate()
	card.Recovery()
	card.stat.death.connect(card._on_death)
	return card

func _on_death():
	var logText = "[{0}] 死亡".format([self.name])
	Events.setlog.emit(logText,Events.LOGLEVEL.ATTACK)
	pass
		

func Recovery():
	self.stat = self.baseStat
	self.stat.Recovery()
	
func GanaMana():
	self.stat.mana += 20

func DealEffect():
	for effect in effect_list.effect_vector:
		effect.Do(self)
	effect_list.Refresh()

func CanAction():
	return self.stat.islive
	
func CanAttacked():
	return self.stat.islive
