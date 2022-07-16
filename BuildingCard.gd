extends "res://Card.gd"


func get_dice():
	var dice = []
	for item in output:
		if item.has('function'):
			pass # TODO: Implement function processing
		else:
			var number = rng.randi_range(item.min, item.max)
			dice.append([item.color, number])
	return dice


func _on_Node2D_mouse_entered():
	print("MOUSE ENTERED")
	pass # Replace with function body.
