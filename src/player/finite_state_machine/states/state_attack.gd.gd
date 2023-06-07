extends AttackState

const ATTACK_GRAVITY = 20

func _ready():
	await owner.ready
	sword.connect("attack_animation_finished", _sword_attack_animation_finished)

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
	
func exit():
	sword.cancel_attack()


func _sword_attack_animation_finished():
	if Input.is_action_just_pressed("attack"):
		state_machine.transition_to("AttackState")
	elif not persistent_state.is_on_floor():
		state_machine.transition_to("FallState")
	elif persistent_state.is_on_floor():
		state_machine.transition_to("IdleState")
