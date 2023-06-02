extends State
class_name AttackState

const ATTACK_GRAVITY = 20

func handle_input(_event: InputEvent):
	pass
	
func update(_delta):
	pass
	
func physics_update(_delta):
	persistent_state.velocity.y = ATTACK_GRAVITY
	_apply_lerp_x(MOVEMENT_LERP_WEIGHT)
	_apply_move_and_slide()
	
func enter(_msg = {}):
	player_animated_sprite.play("idle")
	sword.attack()
	await sword.animation_finished
	
	if not persistent_state.is_on_floor():
		state_machine.transition_to("FallState")
	elif persistent_state.is_on_floor():
		state_machine.transition_to("IdleState")
	
func exit():
	pass

