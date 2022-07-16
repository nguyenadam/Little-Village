extends Node2D


func set_texture(color, value):
	if color == 'brown':
		color = 'red'
	var image = load("res://Assets/Dice/" + str(color) + str(value) +".png")
	$Sprite.set_texture(image)
