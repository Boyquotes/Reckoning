extends StateSkeleton
# extenda a classe de estado que você quer

const RUN_SPEED = 90

func handle_input(_event: InputEvent):
	pass
	
func update(_delta):
	pass
	
func physics_update(_delta):
	_apply_gravity(_delta, GRAVITY, GRAVITY_MAX)
	_apply_movement(RUN_SPEED)
	_apply_lerp_x(MOVEMENT_LERP_WEIGHT)
	_apply_move_and_slide()
	
	if not look_player_raycast.is_colliding() \
	or not look_player_raycast.get_collider().is_in_group("player"):
		state_machine.transition_to("WalkState")
	elif look_player_raycast.get_collider().is_in_group("player") \
	and look_player_raycast.get_collision_point().distance_to(persistent_state.global_position) < ATTACK_DISTANCE:
		state_machine.transition_to("AttackState")

	
func enter(_msg = {}):
	animation_player.play("walk")
	pass
	
func exit():
	pass

