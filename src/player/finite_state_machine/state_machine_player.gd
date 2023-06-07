extends StateMachine

var current_direction = 1 : set = _set_current_direction
var double_jumps = 1
var dashs = 1

var player_animated_sprite: AnimatedSprite2D
var player_sword: Node2D

# funções de configuração
func setup(_persistent_state: CharacterBody2D,
	_raycast_right: RayCast2D,
	_raycast_left: RayCast2D,
	_player_animated_sprite: AnimatedSprite2D, 
	_sword: Node2D):
	
	for child in get_children():
		child.setup(self, _persistent_state, _raycast_right, _raycast_left, _player_animated_sprite, _sword)
		
	self.player_animated_sprite = _player_animated_sprite
	self.player_sword = _sword
	
func start():
	working = true
	transition_to("IdleState")
	
func player_hited():
	transition_to("HitedState")
	
func player_died():
	transition_to("DeathState")
	
func _set_current_direction(new_value):
	current_direction = new_value
	player_animated_sprite.flip_h = new_value < 0
	player_sword.flip_h(new_value < 0)
###########################
