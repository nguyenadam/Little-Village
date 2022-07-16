extends Node2D

var player_cards = []
var card_template = preload('res://Card.tscn')

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
	
	# start the player with a garden and forest
	var garden = card_template.instance()
	garden.init(card_data['garden'].name, card_data['garden'].cost, 
		card_data['garden'].output, card_data['garden'].descr, card_data['garden'].type, 
		card_data['garden'].image_path, card_data['garden'].workers)
	self.add_child(garden)
	player_cards.append(garden)
	
	render_cards()
#	var card = load('res://Card.tscn').instance()
#	self.add_child(card)
#	card.position = Vector2(200, 200)
#
#	var card2 = load('res://Card.tscn').instance()
#	self.add_child(card2)
#	card2.position = Vector2(400, 200)
#
#	var card3 = load('res://Card.tscn').instance()
#	self.add_child(card3)
#	card3.position = Vector2(1100, 200)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _input(ev):
	# end turn
	if ev is InputEventKey and ev.scancode == KEY_T:
		pass

func render_cards():
	for i in len(player_cards):
		player_cards[i].position = Vector2(i * 200 + 200, 200)
