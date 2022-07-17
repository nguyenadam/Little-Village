extends Node2D

var player_cards = []
var current_dice = []
var dice_obj_list = []
var current_shop = []
var card_template = preload('res://BuildingCard.tscn')
var shop_card_template = preload('res://ShopCard.tscn')
var dice_template = preload('res://Dice.tscn')
var player_level
var turn_count = 0
var card_data

var current_selection = {}

const ColorOrder = ['green', 'brown', 'yellow', 'gray']
const SHOP_SIZE = 6

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
	card_data = data_parse.result
	
	$VillageName.bbcode_text = "[center]" + Data.village_name + "[/center]"
	
	# start the player with a wheat field and forest
	generate_player_card('garden')
	generate_player_card('grove')
	generate_player_card('storage_hut')
	
	generate_shop_card()
	generate_shop_card()
	
	render_cards()
	render_shop()
	run_turn()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func run_turn():
	turn_count += 1
	$TurnCount.text = "Turn: " + str(turn_count)
	# reload dice
	current_dice = []
	for card in player_cards:
		current_dice.append_array(card.get_dice())
	print(current_dice)
	
	current_dice.sort_custom(self, "dice_sort")
	render_dice()
	
	# restock shop
	while len(current_shop) < SHOP_SIZE:
		generate_shop_card()
		render_shop()

func generate_player_card(name):
	var card = card_template.instance()
	card.init(name)
	self.add_child(card)
	player_cards.append(card)
	card.connect("clicked", self, "handle_building_card_click")
	render_cards()

func generate_shop_card():
	var card = shop_card_template.instance()
	var name = card_data.keys()[randi() % card_data.keys().size()]
	card.init(name)
	self.add_child(card)
	
	card.show_prices()
	current_shop.append(card)
	card.connect("clicked", self, "handle_shop_card_click")
	return card

func _input(ev):
#	# end turn
	if ev.is_action_pressed("end turn"):
		# lets end the turn
		run_turn()

func handle_building_card_click(card):
	if card.type == 'storage':
		current_selection.card = card
		card.show_glow()
		handle_selection()

func handle_dice_click(dice):
	current_selection.dice = dice
	handle_selection()

func handle_selection():
	print(current_selection)
	if 'card' in current_selection and 'dice' in current_selection and current_selection.card != null and current_selection.dice != null:
		if current_selection.card.add_item(current_selection.dice.get_values()):
			remove_die(current_selection.dice.get_values())
			current_selection.card.hide_glow()
			current_selection.card = null
			current_selection.dice = null
		

func handle_shop_card_click(card):
	print("Clicked " + card.title)
	print(card.get_class())
	var required_dice = card.cost
	var dice_to_use = []
	
	## assume dice are sorted
	var current_check = 0
	for die in current_dice:
		if current_check >= len(required_dice):
			break
		if die[0] == required_dice[current_check][0] and die[1] >= required_dice[current_check][1]:
				# we have a valid dice!
				dice_to_use.append(die)
				current_check += 1
	if current_check >= len(required_dice):
		print("Yes buy")
		# try to remove dice
		if remove_dice(required_dice):
			# gives the play a card
			generate_player_card(card.id)
			# removes the card from the shop
			for i in len(current_shop):
				var curcard = current_shop[i]
				if curcard.id == card.id:
					print("Card removed!")
					current_shop.remove(i)
					curcard.queue_free()
					break
			render_cards()
			render_shop()
	else:
		print("No buy")

## rendering functions

func render_cards():
	for i in len(player_cards):
		player_cards[i].position = Vector2(i % 5 * 200 + 150, (i / 5) * 100 + 250)

func render_shop():
	for i in len(current_shop):
		current_shop[i].position = Vector2(i % 3 * 200 + 1200, 250 + (i / 3) * 200)

func render_dice():
	derender_dice()
	for i in len(current_dice):
		var dice = dice_template.instance()
		dice.set_texture(current_dice[i][0], current_dice[i][1])
		self.add_child(dice)
		dice_obj_list.append(dice)
		dice.position = Vector2(i * 100 + 200, 870)
		dice.connect("clicked", self, "handle_dice_click")

func derender_dice():
	for die in dice_obj_list:
		die.queue_free()
	dice_obj_list = []

## utility functions

# wrapper for single die
func remove_die(die):
	return remove_dice([die])

# dice_to_remove is just a list of dice, where each dice is a 2 slot array
func remove_dice(dice_to_remove):
	print("Trying to remove " + str(dice_to_remove))
	# assume both lists are sorted
	assert(len(dice_to_remove) <= len(current_dice))
	var current_to_remove = 0
	var current_in_list = 0
	var dice_list = current_dice.duplicate(true)
	while (current_to_remove < len(dice_to_remove) and current_in_list < len(dice_list)):
		if dice_list[current_in_list][0] == dice_to_remove[current_to_remove][0] and dice_list[current_in_list][1] >= dice_to_remove[current_to_remove][1]:
			dice_list.remove(current_in_list)
			current_to_remove += 1
		else:
			current_in_list += 1
	
	if current_to_remove == len(dice_to_remove):
		# sucessfully removed all things
		current_dice = dice_list
		print(current_dice)
		render_dice()
		return true
	else:
		# unable to remove all things
		print("Unable to remove")
		print("Only have " + str(current_dice))
		render_dice()
		return false

func dice_sort(a, b):
	if a[0] != b[0]:
		return ColorOrder.find(a[0]) < ColorOrder.find(b[0])
	else:
		return a[1] < b[1]

func are_array_equal(a, b):
	if len(a) != len(b):
		return false
	for i in len(a):
		if a[i] != b[i]:
			return false
	return true
