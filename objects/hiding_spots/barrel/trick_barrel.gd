extends LaughingBarrel
class_name TrickBarrel
# If Mopsa is hiding in a trick barrel it will swap locations with an uncecked
# empty barrel when the player approaches it, ensuring that the player's first
# initial guesses are always wrong.


var checked := false


func on_frob():
	.on_frob()
	checked = true


func _on_Area_body_entered(body):
	if body is Player and user != null:
		# Mopsa is hiding here.
		# Find an unchecked empty barrel to swap locations with.
		for spot in get_tree().get_nodes_in_group("hiding_spots"):
			if spot == self:
				continue
			
			if "checked" in spot and not spot.checked:
				var new_location = spot.global_transform.origin
				spot.global_transform.origin = global_transform.origin
				global_transform.origin = new_location
				var user_y = user.global_transform.origin.y
				user.global_transform.origin = new_location
				user.global_transform.origin.y = user_y
				Logger.info("Trick barrel swapped location")
				return
