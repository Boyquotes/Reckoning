extends StateMachine

var current_direction = 1 : set = _set_current_direction

# funções de configuração
func setup():
	pass
	
func start():
	working = true
	
func player_hited():
	pass
	
func player_died():
	pass
	
func _set_current_direction(new_value):
	current_direction = new_value
###########################
