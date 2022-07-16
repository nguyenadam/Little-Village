extends Node2D

var title
var cost
var output
var description
var type
var workers_required
var workers_current
var stored

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
	
	title = card_data[name].name
	cost = card_data[name].cost
	output = card_data[name].output
	description = card_data[name].descr
	type = card_data[name].type
	workers_required = card_data[name].workers
	
	print("Card Created!")


