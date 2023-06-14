extends StateSkeleton
# extenda a classe de estado que você quer

const DEATH_TIME = 2.0

func handle_input(_event: InputEvent):
	pass
	
func update(_delta):
	pass
	
func physics_update(_delta):
	persistent_state.velocity = Vector2.ZERO
	
	var total = animation_player.current_animation_length
	var pos = animation_player.current_animation_position
	if abs(total - pos) <= 0.1:
		persistent_state.queue_free()
		
	
func enter(_msg = {}):
	animation_player.play("death")
	
func exit():
	pass

