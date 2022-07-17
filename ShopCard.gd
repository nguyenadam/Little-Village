extends "res://Card.gd"
signal clicked(node)

func _ready():
	$cost1.hide()
	$cost2.hide()
	$cost3.hide()
	$cost4.hide()
	$glow.hide()

func init(name):
	.init(name)
	isShop = true
	

func show_prices():
	if len(cost) >= 1:
		set_cost_dice($cost1, cost[0])
	if len(cost) >= 2:
		set_cost_dice($cost2, cost[1])
	if len(cost) >= 3:
		set_cost_dice($cost3, cost[2])
	if len(cost) >= 4:
		set_cost_dice($cost3, cost[3])
	
func set_cost_dice(obj, item):
	var color = item[0]
	if color == 'brown':
		color = 'red'
	var image = load("res://Assets/Dice/" + str(color) + str(item[1]) +".png")
	obj.set_texture(image)
	obj.show()


func _on_Node2D_mouse_entered():
	#print("MOUSE ENTERED!")
	pass

func _on_Node2D_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("mouse_button_left"):
		emit_signal("clicked", self)

func show_glow():
	$glow.show()

func hide_glow():
	$glow.hide()
