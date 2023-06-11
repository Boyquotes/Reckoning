extends StateSkeleton
# extenda a classe de estado que você quer

const AWAIT_TIME = 1.0

func handle_input(_event: InputEvent):
	pass
	
func update(_delta):
	pass
	
func physics_update(_delta):
	persistent_state.velocity.x = 0
	_apply_gravity(_delta, GRAVITY, GRAVITY_MAX)
	_apply_move_and_slide()
	
	var total = animation_player.current_animation_length
	var pos = animation_player.current_animation_position
	
	if abs(total - pos) < 0.1:
		state_machine.transition_to("IdleState", {"time_to_attack": AWAIT_TIME})
	
func enter(_msg = {}):
	animation_player.play("attack")
	
func exit():
	pass

