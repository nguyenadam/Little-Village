extends "res://Card.gd"
signal clicked(node)

func _ready():
	$store1.hide()
	$glow.hide()

func get_dice():
	if type == 'storage':
		var out = stored.duplicate()
		$store1.hide()
		stored = []
		return out
	
	var dice = []
	for item in output:
		if item.has('function'):
			pass #todo
		else:
			var number = rng.randi_range(item.min, item.max)
			dice.append([item.color, number])
	return dice

func add_item(a):
	var item = a.duplicate()
	if len(stored) < storage_capacity:
		stored.append(item)
		var color = item[0]
		if color == 'brown':
			color = 'red'
		var image = load("res://Assets/Dice/" + str(color) + str(item[1]) +".png")
		if len(stored) == 1:
			$store1.set_texture(image)
			$store1.show()
		print("ADDED ITEM " + str(item))
		return true
	else:
		return false

func _on_Node2D_mouse_entered():
	print("MOUSE ENTERED")
	pass # Replace with function body.

func _on_Node2D_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("mouse_button_left"):
		emit_signal("clicked", self)

func show_glow():
	$glow.show()

func hide_glow():
	$glow.hide()
