extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$Name.align = LineEdit.ALIGN_CENTER


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Button_button_down():
	Data.village_name = $Name.get_text()
	get_tree().change_scene("res://Game.tscn")
