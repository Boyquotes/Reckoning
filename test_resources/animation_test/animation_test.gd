extends Node2D


@onready var animation_player = $AnimationPlayer

func _process(delta):
	animation_player.play("moving")
	var total_animation = animation_player.current_animation_length
	var current_position = animation_player.current_animation_position
	if abs(total_animation - current_position) < 0.2:
		print("terminou krlh")
