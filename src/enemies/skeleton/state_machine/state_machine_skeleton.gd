extends StateMachine
class_name StateMachineSkeleton

# funções de configuração
func setup(_persistent_state: CharacterBody2D,
	_animation_player: AnimationPlayer,
	_look_player: RayCast2D):
	
	for state in get_children():
		state.setup(self, 
		_persistent_state, _animation_player, _look_player)
	
	
func start():
	working = true
	
func player_hited():
	transition_to("HitedState")
	
func player_died():
	transition_to("DeathState")
###########################

