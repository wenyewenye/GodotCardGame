class_name Stat
extends Resource

signal stats_change

@export var max_health:int  = 500
@export var art: Texture
@export var skill_mana: int = 100
@export var base_attack: int = 50
@export var start_mana: int = 0

var damage_increase : float : set = set_damage_increase
var damage_reduction : float : set = set_damage_reduction
var additional_damage :int = 0
var health : int : set = set_health
var block : int : set = set_block
var attack:int = 0
var mana : int = 0
var islive := true
signal death


func _init():
	health = max_health
	damage_increase = 1.0
	damage_reduction = 1.0
	mana = start_mana
	attack = base_attack
	
func set_damage_increase(value :float)->void:
	damage_increase = clampf(value,0,Global.MAX_VALUE)

func set_damage_reduction(value :float)->void:
	damage_reduction = clampf(value,0,Global.MAX_VALUE)

func set_health(value :int)->void:
	health = clampi(value,0,max_health)
	stats_change.emit()
	
func set_block(value :int)->void:
	block = clampi(value,0,999)
	stats_change.emit()

func take_damage(damgae :int)->void:
	if damgae <= 0:
		return
	
	self.health -= clampi(damgae - block,0,max_health)
	block -= damgae
	if self.health == 0:
		self.islive = false
		death.emit()

func turn_start():
	self.block = 0

func heal(value :int)->void:
	health += value
	
func create_instance()-> Resource:
	var instance:Stat = self.duplicate()
	instance.health = max_health
	instance.block = 0
	instance.mana = start_mana
	return instance
	
func animate():
	pass

func Recovery():
	self.health = self.max_health
	self.mana =  self.start_mana
