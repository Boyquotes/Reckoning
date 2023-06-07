extends IdleState

func handle_input(_event: InputEvent):
	pass
	
func update(_delta):
	pass
	
func physics_update(_delta):
	persistent_state.velocity.x = 0
	_apply_gravity(_delta)
	_apply_lerp_x(MOVEMENT_LERP_WEIGHT)
	_apply_move_and_slide()
	
	if Input.is_action_pressed("move_right") \
	or Input.is_action_pressed("move_left"):
		state_machine.transition_to("WalkState")
	elif not persistent_state.is_on_floor():
		state_machine.transition_to("FallState")
	elif Input.is_action_just_pressed("attack"):
		state_machine.transition_to("AttackState")
	elif Input.is_action_just_pressed("jump"):
		state_machine.transition_to("JumpState")
	elif Input.is_action_just_pressed("dash") and state_machine.dashs != 0:
		state_machine.transition_to("DashState")
	
func enter(_msg = {}):
	player_animated_sprite.play("idle")
	
	state_machine.double_jumps = 1
	state_machine.dashs = 1
	
func exit():
	pass
