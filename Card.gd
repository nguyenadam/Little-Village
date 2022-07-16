extends Node2D

var title
var cost
var output
var description
var type
var workers_required
var workers_current


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func init(tit, co, out, desc, t, workers, image):
	title = tit
	cost = co
	output = out
	description = desc
	type = t
	workers_required = workers
	print("Card Created!")
