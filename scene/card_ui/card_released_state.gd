extends CardState

func enter() -> void:
	card_ui.active_pos = -1
	if card_ui.board != null:
		card_ui.active_requested.emit(card_ui)
		transition_requested.emit(self, CardState.State.BASE)
	pass



func on_input(event: InputEvent) -> void:
	var cancel = event.is_action_pressed("right_mouse") and card_ui.isfocus
	if  card_ui.active_pos == -1:
		transition_requested.emit(self, CardState.State.BASE)
	if cancel:
		card_ui.deactive_requested.emit(card_ui)
		card_ui.queue_free()

func on_mouse_entered() -> void:
	Events.card_tip_show.emit(card_ui.pic.texture,card_ui.card)
	pass


func on_mouse_exited() -> void:
	Events.card_tip_hide.emit()
	pass
