class_name CardStateMachine
extends Node

@export var initial_state: CardState

var current_state: CardState
var states := {}


func init(card: CardUI) -> void:
	for child: CardState in get_children():
		if child:
			states[child.state] = child
			if not child.transition_requested.is_connected(_on_transition_requested):
				child.transition_requested.connect(_on_transition_requested)
			child.card_ui = card
	
	if initial_state:
		initial_state.enter()
		current_state = initial_state


func on_input(event: InputEvent) -> void:
	if current_state:
		current_state.on_input(event)


func on_gui_input(event: InputEvent) -> void:
	if current_state:
		current_state.on_gui_input(event)


func on_mouse_entered() -> void:
	if current_state:
		current_state.on_mouse_entered()


func on_mouse_exited() -> void:
	if current_state:
		current_state.on_mouse_exited()


func _on_transition_requested(from: CardState, to: CardState.State) -> void:
	if from != current_state:
		return
		
	var new_state: CardState = states[to]
	if not new_state:
		return
	
	if current_state:
		current_state.exit()
	
	new_state.enter()
	current_state = new_state

func TransState(target_state: CardState.State):
	var states = get_children()
	var index = states.find_custom(func(value):
		return target_state == value.state)
	self.initial_state = states[index]
	self.init(initial_state.card_ui)
	
