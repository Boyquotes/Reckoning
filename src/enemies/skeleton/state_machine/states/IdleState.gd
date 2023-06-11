extends StateSkeleton
# extenda a classe de estado que você quer

var time_to_attack: Timer

func _ready():
	time_to_attack = Timer.new()
	time_to_attack.connect("timeout", _on_time_to_attack_timeout)
	add_child(time_to_attack)
	
func handle_input(_event: InputEvent):
	pass
	
func update(_delta):
	pass
	
func physics_update(_delta):
	persistent_state.velocity.x = 0
	_apply_gravity(_delta, GRAVITY, GRAVITY_MAX)
	_apply_move_and_slide()
	
func enter(_msg = {}):
	animation_player.play("idle")
	if _msg.has("time_to_attack"):
		time_to_attack.start(_msg.time_to_attack)
	
func exit():
	time_to_attack.stop()

func _on_time_to_attack_timeout():
	if not look_player_raycast.is_colliding() \
	or not look_player_raycast.get_collider().is_in_group("player"):
		state_machine.transition_to("WalkState")
	elif look_player_raycast.get_collider().is_in_group("player"):
		if look_player_raycast.get_collision_point().distance_to(persistent_state.global_position) < ATTACK_DISTANCE:
			state_machine.transition_to("AttackState")
		else:
			state_machine.transition_to("RunState")
