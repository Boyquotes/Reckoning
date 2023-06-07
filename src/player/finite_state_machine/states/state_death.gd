extends DeathState

const DEATH_TRAUMA = 0.2

func handle_input(_event: InputEvent):
	pass
	
func update(_delta):
	pass
	
func physics_update(_delta):
	pass
	
func enter(_msg = {}):
	persistent_state.velocity = Vector2.ZERO
	state_machine.trauma_requisiton(DEATH_TRAUMA)
	player_animated_sprite.play("death")
	
func exit():
	pass

