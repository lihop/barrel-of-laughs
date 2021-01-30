extends Node


signal player_closed_eyes()
signal player_opened_eyes()
signal countdown_completed()
signal hider_found()
signal player_guessed_wrong()


var seeking = true
var barrels_remaining = null


func _ready():
	connect("hider_found", self, "_on_hider_found")
	connect("countdown_completed", self, "set", ["seeking", true])	


func _on_hider_found():
	seeking = false
