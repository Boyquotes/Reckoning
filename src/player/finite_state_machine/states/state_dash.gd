extends State
class_name DashState

const DASH_FORCE = 400
const DASH_LERP_WEIGHT = 0.1

func handle_input(_event: InputEvent):
	pass
	
func update(_delta):
	pass
	
func physics_update(_delta):
	_apply_move_and_slide()
	_apply_lerp_x(DASH_LERP_WEIGHT)
	_apply_lerp_y(DASH_LERP_WEIGHT)
	
	if abs(persistent_state.velocity.x) <= 40 and abs(persistent_state.velocity.y) <= 40:
		state_machine.transition_to("FallState")
	
func enter(_msg = {}):
	persistent_state.invencible(true)
	
	var dash_direction = Vector2(0, 0)
	var sides = Input.get_axis("move_left", "move_right")
	var up = 0
	if Input.is_action_pressed("move_up"):
		up = 1
			
	if sides == 0 and up == 0:
		dash_direction = Vector2(state_machine.current_direction, 0)
	elif sides == 0 and up != 0:
		dash_direction = Vector2(0, -1)
	elif sides != 0 and up == 0:
		dash_direction = Vector2(sides, 0)
	else:
		dash_direction = Vector2(sides, -1)
			
	dash_direction = dash_direction.normalized() * DASH_FORCE
	persistent_state.velocity = dash_direction
	
	state_machine.dashs -= 1
		
	
func exit():
	persistent_state.invencible(false)

