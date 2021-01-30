extends AudioStreamPlayer


func play_wrong():
	var player = duplicate()
	player.stream = preload("res://singletons/sounds/assets/final/wrong_buzzer.wav")
	add_child(player)
	player.play()
	yield(player, "finished")
	player.queue_free()


func play_congratulations():
	var player = duplicate()
	player.stream = preload("res://singletons/sounds/assets/final/congratulations.wav")
	add_child(player)
	player.play()
	yield(player, "finished")
	player.queue_free()


func play_level_complete():
	var player = duplicate()
	player.stream = preload("res://singletons/sounds/assets/final/level_complete.wav")
	add_child(player)
	player.play()
	yield(player, "finished")
	player.queue_free()
