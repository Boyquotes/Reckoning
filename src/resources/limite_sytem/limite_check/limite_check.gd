extends Area2D

signal limite_collided

func _on_area_entered(area):
	emit_signal("limite_collided")
