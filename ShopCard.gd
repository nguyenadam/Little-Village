extends "res://Card.gd"
signal clicked(node)

func _on_Node2D_mouse_entered():
	#print("MOUSE ENTERED!")
	pass

func _on_Node2D_input_event(viewport, event, shape_idx):
	if Input.is_action_pressed("mouse_button_left"):
		emit_signal("clicked", self)

