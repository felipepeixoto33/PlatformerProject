extends Area2D

var player = null;

func can_see_player():
	print("Retornou")
	return player != null;

func _on_PlayerDetectionZone_body_entered(body):
	if body.is_in_group("Player"):
		player = body
		can_see_player()

func _on_PlayerDetectionZone_body_exited(body):
	player = null



