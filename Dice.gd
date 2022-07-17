extends Node2D
signal clicked(node)

var col
var val

func try_set_texture(color, value):
	col = color
	if color == 'brown':
		color = 'red'
	var image = load("res://Assets/Dice/" + str(color) + str(value) +".png")
	$Sprite.set_texture(image)
	val = value

func get_values():
	return [col, val]

func _on_Dice_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("mouse_button_left"):
		emit_signal("clicked", self)
