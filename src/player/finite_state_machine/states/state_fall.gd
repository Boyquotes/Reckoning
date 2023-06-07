extends FallState

func handle_input(_event: InputEvent):
	pass
	
func update(_delta):
	pass
	
func physics_update(_delta):
	_apply_gravity(_delta)
	_apply_movement(MOVEMENT_SPEED)
	_apply_lerp_x(MOVEMENT_LERP_WEIGHT)
	_apply_move_and_slide()
	
	if persistent_state.is_on_floor() and Input.get_axis("move_left", "move_right") == 0:
		state_machine.transition_to("IdleState")
	elif persistent_state.is_on_floor() and Input.get_axis("move_left", "move_right") != 0:
		state_machine.transition_to("WalkState")
	elif Input.is_action_just_pressed("attack"):
		state_machine.transition_to("AttackState")
	elif Input.is_action_just_pressed("jump") \
	and (raycast_right.is_colliding() or raycast_left.is_colliding()):
		state_machine.transition_to("WallJumpState")
	elif Input.is_action_just_pressed("jump") and state_machine.double_jumps != 0:
		state_machine.transition_to("DoubleJumpState")
	elif Input.is_action_just_pressed("dash") and state_machine.dashs != 0:
		state_machine.transition_to("DashState")

	
func enter(_msg = {}):
	player_animated_sprite.play("fall")
	
func exit():
	pass

