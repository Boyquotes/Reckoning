extends StateSkeleton
# extenda a classe de estado que você quer
const WALK_SPEED = 30

func handle_input(_event: InputEvent):
	pass
	
func update(_delta):
	pass
	
func physics_update(_delta):
	animation_player.play("walk")
	_apply_gravity(_delta, GRAVITY, GRAVITY_MAX)
	_apply_movement(WALK_SPEED)
	_apply_move_and_slide()
	
	if look_player_raycast.is_colliding() and look_player_raycast.get_collider().is_in_group("player"):
		state_machine.transition_to("RunState")
	
func enter(_msg = {}):
	pass
	
func exit():
	pass

