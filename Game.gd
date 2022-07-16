extends Node2D

var player_cards = []
var current_dice = []
var dice_obj_list = []
var current_shop = []
var card_template = preload('res://BuildingCard.tscn')
var shop_card_template = preload('res://ShopCard.tscn')
var dice_template = preload('res://Dice.tscn')
var player_level

const ColorOrder = ['green', 'brown', 'yellow', 'gray']

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
	
	var garden3 = card_template.instance()
	garden3.init('garden')
	self.add_child(garden3)
	player_cards.append(garden3)
	
	var grove = card_template.instance()
	grove.init('grove')
	self.add_child(grove)
	player_cards.append(grove)
	
	generate_shop_card()
	generate_shop_card()
	
	render_cards()
	render_shop()
	run_turn()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func run_turn():
	current_dice = []
	for card in player_cards:
		current_dice.append_array(card.get_dice())
	print(current_dice)
	current_dice.sort_custom(self, "dice_sort")
	render_dice()

func generate_player_card(name):
	var card = card_template.instance()
	card.init(name)
	self.add_child(card)
	player_cards.append(card)
	render_cards()

func generate_shop_card():
	var card = shop_card_template.instance()
	card.init('garden')
	self.add_child(card)
	current_shop.append(card)
	card.connect("clicked", self, "handle_shop_card_click")
	return card

func _input(ev):
	# end turn
	if ev is InputEventKey and ev.scancode == KEY_T:
		pass

func handle_shop_card_click(card):
	print("Clicked " + card.title)
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
		player_cards[i].position = Vector2(i * 200 + 200, 200)

func render_shop():
	for i in len(current_shop):
		current_shop[i].position = Vector2(1600, 200 + i * 100)

func render_dice():
	for i in len(current_dice):
		var dice = dice_template.instance()
		dice.set_texture(current_dice[i][0], current_dice[i][1])
		self.add_child(dice)
		dice_obj_list.append(dice)
		dice.position = Vector2(i * 100 + 800, 900)

func derender_dice():
	for die in dice_obj_list:
		die.free()

## utility functions

func remove_dice(dice_to_remove):
	derender_dice()
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
