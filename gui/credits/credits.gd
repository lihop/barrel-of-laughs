extends "res://addons/godot-credits/GodotCredits.gd"

signal finished()

export(String, FILE, "*.json") var credits_file
var file = File.new()

func _ready():
	file.open(credits_file, file.READ)
	credits = parse_json(file.get_as_text())
	file.close()


func _enter_tree():
	speed_up = true
	yield(get_tree().create_timer(1), "timeout")
	speed_up = false


func finish():
	.finish()
	emit_signal("finished")
