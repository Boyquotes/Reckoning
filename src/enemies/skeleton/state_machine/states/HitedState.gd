extends StateSkeleton
# extenda a classe de estado que você quer

func handle_input(_event: InputEvent):
	pass
	
func update(_delta):
	pass
	
func physics_update(_delta):
	persistent_state.velocity = Vector2.ZERO
	
	var total = animation_player.current_animation_length
	var pos = animation_player.current_animation_position
	
	if abs(total - pos) <= 0.1:
		state_machine.transition_to("WalkState")
	
func enter(_msg = {}):
	animation_player.play("hited")
	
func exit():
	pass

