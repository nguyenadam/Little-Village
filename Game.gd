extends Node2D

var player_cards = []
var current_dice = []
var card_template = preload('res://BuildingCard.tscn')
var dice_template = preload('res://Dice.tscn')
var player_level

# Called when the node enters the scene tree for the first time.
func _ready():
	# load card info

	
	# start the player with a wheat field and forest
	var garden = card_template.instance()
	garden.init('garden')
	self.add_child(garden)
	player_cards.append(garden)
	
	var garden2 = card_template.instance()
	garden2.init('garden')
	self.add_child(garden2)
	player_cards.append(garden2)
	
	var grove = card_template.instance()
	grove.init('grove')
	self.add_child(grove)
	player_cards.append(grove)
	
	render_cards()
	run_turn()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func run_turn():
	current_dice = []
	for card in player_cards:
		current_dice.append_array(card.get_dice())
	print(current_dice)
	render_dice()

func _input(ev):
	# end turn
	if ev is InputEventKey and ev.scancode == KEY_T:
		pass

func render_cards():
	for i in len(player_cards):
		player_cards[i].position = Vector2(i * 200 + 200, 200)

func render_dice():
	for i in len(current_dice):
		var dice = dice_template.instance()
		dice.set_texture(current_dice[i][0], current_dice[i][1])
		self.add_child(dice)
		dice.position = Vector2(i * 100 + 800, 900)
