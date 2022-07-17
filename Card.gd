extends Node2D

var id
var title
var cost
var output
var description
var type
var workers_required
var workers_current
var stored
var storage_capacity
var isShop = false

var rng = RandomNumberGenerator.new()
# Called when the node enters the scene tree for the first time.
func _ready():
	# TODO: uncomment out for release
	rng.randomize()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func init(name):
	var data_file = File.new()
	if data_file.open("res://card_data.json", File.READ) != OK:
		return
	var data_text = data_file.get_as_text()
	data_file.close()
	var data_parse = JSON.parse(data_text)
	if data_parse.error != OK:
		return
	var card_data = data_parse.result
	
	id = name
	title = card_data[name].name
	cost = []
	for dice in card_data[name].cost:
		cost.append(dice.values())
	output = card_data[name].output
	description = card_data[name].descr
	type = card_data[name].type
	workers_required = card_data[name].workers
	stored = []
	storage_capacity = len(card_data[name].input)
	
	$Sprite.set_texture(load("res://" + card_data[name].image_path))
	print("Card Created!")

func add_item(item):
	return false

