extends AudioStreamPlayer

var _music_list = (["A New World We Haven't Met", "A Song to Remember Me By",
	"An Empty Realm", "Bow Bow Bow (Wow)", "Industrialization", "Innocence",
	"Jam, Game, Jam!", "Nebula", "Patience, Growth", "The Crowning of a New King",
	"Time to Click!", "Time to Jam, Time to Grind", "Torches Along the Shore",
	"Wanderlust", "Weekend", "We're Here, Beneath the Veil"])



# Called when the node enters the scene tree for the first time.
func _ready():
	var song = _music_list[randi() % _music_list.size()]
	song = "res://Assets/Music/" + song + ".mp3"
	stream = load(song)
	play()

func _on_AudioStreamPlayer_finished():
	var song = _music_list[randi() % _music_list.size()]
	song = "res://Assets/Music/" + song + ".mp3"
	stream = load(song)
	play()
