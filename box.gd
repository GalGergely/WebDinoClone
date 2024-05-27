extends Area2D

signal hit

func _on_body_entered(body):
	print("hit")
	hit.emit()
