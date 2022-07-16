extends Node2D

var player_cards = []
var current_dice = []
var card_template = preload('res://Card.tscn')
var player_level

# Called when the node enters the scene tree for the first time.
func _ready():
	# load card info
	var data_file = File.new()
	if data_file.open("res://card_data.json", File.READ) != OK:
		return
	var data_text = data_file.get_as_text()
	data_file.close()
	var data_parse = JSON.parse(data_text)
	if data_parse.error != OK:
		return
	var card_data = data_parse.result
	
	# start the player with a wheat field and forest
	var garden = card_template.instance()
	var card_name = 'garden'
	garden.init(card_data[card_name].name, card_data[card_name].cost, 
		card_data[card_name].output, card_data[card_name].descr, card_data[card_name].type, 
		card_data[card_name].image_path, card_data[card_name].workers)
	self.add_child(garden)
	player_cards.append(garden)
	
	var grove = card_template.instance()
	card_name = 'grove'
	grove.init(card_data[card_name].name, card_data[card_name].cost, 
		card_data[card_name].output, card_data[card_name].descr, card_data[card_name].type, 
		card_data[card_name].image_path, card_data[card_name].workers)
	self.add_child(grove)
	player_cards.append(grove)
	
	render_cards()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func run_turn():
	for card in player_cards:
		current_dice.append(card.get_dice())

func _input(ev):
	# end turn
	if ev is InputEventKey and ev.scancode == KEY_T:
		pass

func render_cards():
	for i in len(player_cards):
		player_cards[i].position = Vector2(i * 200 + 200, 200)
