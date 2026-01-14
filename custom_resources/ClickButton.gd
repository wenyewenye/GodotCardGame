extends TextureButton
class_name  ClickButton
var flag:int = 0
var index = 0

func _init() -> void:
	self.ignore_texture_size = true
	self.modulate =  Color(0.6, 0.6, 0.6)
	self.stretch_mode = TextureButton.STRETCH_SCALE
	self.custom_minimum_size = Vector2(32, 48)


func _gui_input(event):
	if event is InputEventMouseButton:
		if event.pressed:
			match event.button_index:
				MOUSE_BUTTON_LEFT: 
					self.modulate =  Color(0.2, 0.2, 0.2)
					flag = 2
				MOUSE_BUTTON_RIGHT:
					self.modulate =  Color(1, 1, 1)
					flag = 1
				MOUSE_BUTTON_MIDDLE:
					self.modulate =  Color(0.6, 0.6, 0.6)
					flag = 0
					
