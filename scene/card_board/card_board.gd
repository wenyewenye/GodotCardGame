extends Node2D
class_name  CardBoard

@onready var board: Area2D = $Board
@onready var color_rect: ColorRect = $Board/ColorRect
static var Card_Positons : Array[Vector2] = [Vector2(0,0), Vector2(100,0), Vector2(200,0),
										Vector2(0,140), Vector2(100,140), Vector2(200,140)]

var cards : Array[CardUI] = [null,null,null,null,null,null]


func _input(event: InputEvent) -> void:
	pass

func _on_gui_input(event: InputEvent) -> void:
	pass


func _on_mouse_entered() -> void:
	pass


func _on_mouse_exited() -> void:
	pass


func _on_active_signl(input_card:CardUI) -> void:
	var card:CardUI = input_card.Copy()
	add_child(card)
	
	card.card_state_machine.TransState(CardState.State.RELEASED)
	
	var distances_array = Card_Positons.map(func(vec:Vector2):
						return vec.distance_to(card.position - self.position);
	)
	var index = distances_array.find(distances_array.min())
	#card.position = self.position + Card_Positons[index]
	card.position =  Card_Positons[index]
	card.active_pos = index
	card.card.pos = index
	cards[index] = card
	pass

func _on_deactive_signl(card:CardUI) -> void:
	cards[card.active_pos] = null

func IsEmpty():
	return cards.all(func(card):
		return card == null)

func SetCardPos(cards:Array[CardUI],pos):
	for i in range(cards.size()):
		self.add_child(cards[i])
		cards[i].card_state_machine.TransState(CardState.State.RELEASED)
		cards[i].active_pos = pos[i]
		cards[i].card.pos = pos[i]
		cards[i].board = self
		cards[i].InitCardTeam()
		
		self.cards[pos[i]] = cards[i]
		cards[i].position =  CardBoard.Card_Positons[pos[i]]

func GetCardIndex():
	var card_index = []
	for card in self.cards:
		if card != null:
			card_index.append(card.card.index)
		else:
			card_index.append(-1)
	return card_index
