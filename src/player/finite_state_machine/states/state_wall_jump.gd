extends StatePlayer

const WALL_JUMP_FORCE = 200
const WALL_JUMP_LERP_WEIGHT = 0.05

func handle_input(_event: InputEvent):
	pass
	
func update(_delta):
	pass
	
func physics_update(_delta):
	_apply_gravity(_delta)
	_apply_lerp_x(WALL_JUMP_LERP_WEIGHT)
	_apply_move_and_slide()
	
	if abs(persistent_state.velocity.x) <= 1 or persistent_state.velocity.y >= 0:
		state_machine.transition_to("FallState")
		
	
func enter(_msg = {}):
	persistent_state.velocity.y = -JUMP_FORCE
	if raycast_right.is_colliding():
		persistent_state.velocity.x = -WALL_JUMP_FORCE
		state_machine.current_direction = -1
	elif raycast_left.is_colliding():
		persistent_state.velocity.x = WALL_JUMP_FORCE
		state_machine.current_direction = 1
	
func exit():
	pass

