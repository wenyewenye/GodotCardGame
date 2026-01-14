extends Control
#class_name DrawControl
@onready var damage_button: CheckButton = $DamageButton
@onready var receive_button: CheckButton = $ReceiveButton

var draw_array = []
var img_array = []
var statistic_array = []
var color_array = [Color(1,0.2,0.3),Color(0.5,0.7,0.3),Color(0.1,0.2,0.7),Color(1,0.2,0.7)]
var default_font = ThemeDB.fallback_font
var default_font_size = ThemeDB.fallback_font_size
func _ready() -> void:
	UpdateDrawArray()
	damage_button.pressed.connect(self.UpdateDrawArray)
	receive_button.pressed.connect(self.UpdateDrawArray)
	pass

func _draw() -> void:
	if draw_array.is_empty():
		return
	var bar_num = draw_array.size()
	var color_index = 0
	var BaseOffset = 400
	var width = ((self.size[0]-BaseOffset)/12)
	var barWidth = width/bar_num
	var y = self.size[1] - 100
	for i in range(12):
		if img_array[i] != null:
				if img_array[i].get_height() != 100:
					var image = img_array[i].get_image()
					image.resize(width, 100, Image.INTERPOLATE_NEAREST)
					img_array[i] = ImageTexture.create_from_image(image)
				draw_texture(img_array[i],Vector2(BaseOffset + width * i,y))
	for j in range(draw_array.size()):
		var array = draw_array[j]

		var max_v = array.max()
		for i in range(12):
			if i == 6:
				color_index+=1
			var height  = (self.size[1] - 100) * array[i]/max_v
			draw_rect(Rect2(BaseOffset + width * i + j * barWidth,y - height,barWidth,height),color_array[color_index],true)
			
			draw_rect(Rect2(BaseOffset +  width * i + j * barWidth,y - height,barWidth,height),Color(1,1,1),false,2)
			draw_string(default_font, Vector2(BaseOffset +  width * i + j * barWidth,y - height - 2), str(array[i]), 
				HORIZONTAL_ALIGNMENT_CENTER, barWidth, default_font_size)

		color_index+=1	

func initData(statistic_array):
	
	self.statistic_array = statistic_array
	pass
	
func GetDataArray(append_func:Callable):
	var data_array = []
	for stat in statistic_array:
		if stat == null:
			data_array.append(0)
		else:
			append_func.call(data_array,stat)
	return data_array
			#draw_array.append(stat.damageMaking)
	

func InitImg(input_img_array):
	img_array = input_img_array

func UpdateDrawArray():
	if self.statistic_array.is_empty():
		return
	var temp_arry = []
	draw_array = []
	if damage_button.button_pressed:
		temp_arry = GetDataArray(func(data_array,stat):data_array.append(stat.damageMaking))
		if not temp_arry.is_empty():
			draw_array.append(temp_arry)
	if receive_button.button_pressed:
		temp_arry = GetDataArray(func(data_array,stat):data_array.append(stat.damageTaking))
		if not temp_arry.is_empty():
			draw_array.append(temp_arry)
	self.queue_redraw()
	pass
