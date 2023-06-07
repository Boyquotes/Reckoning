extends State
class_name DashState

var DASH_GHOST_PRELOAD = preload("res://src/player/effects/dash_ghost/dash_ghost.tscn")

const DASH_FORCE = 400
const DASH_LERP_WEIGHT = 0.1
const DASH_TRAUMA = 0.2

var can_create_dash_effects = true
var create_dash_effects_time = 0.018
var dash_effects_timer: Timer

func _ready():
	dash_effects_timer = Timer.new()
	dash_effects_timer.connect("timeout", _on_dash_effects_timeout)
	add_child(dash_effects_timer)

func handle_input(_event: InputEvent):
	pass
	
func update(_delta):
	pass
	
func physics_update(_delta):
	if can_create_dash_effects:
		var d = _create_dash_ghot()
		persistent_state.create_instance(d)
		can_create_dash_effects = false
		dash_effects_timer.start(create_dash_effects_time)
	
	_apply_move_and_slide()
	_apply_lerp_x(DASH_LERP_WEIGHT)
	_apply_lerp_y(DASH_LERP_WEIGHT)
	
	if abs(persistent_state.velocity.x) <= 40 and abs(persistent_state.velocity.y) <= 40:
		state_machine.transition_to("FallState")
	
func enter(_msg = {}):
	state_machine.trauma_requisiton(DASH_TRAUMA)
	
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


# funções da classe dash
func _create_dash_ghot():
	var dg = DASH_GHOST_PRELOAD.instantiate()
	dg.global_position = persistent_state.global_position
	dg.flip_h = state_machine.current_direction == -1
	return dg

func _on_dash_effects_timeout():
	can_create_dash_effects = true
