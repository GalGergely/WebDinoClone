extends Area2D

signal hit

func _on_body_entered(body):
	if body.name == "BlueDragon":
		hit.emit()
		print("hit")
