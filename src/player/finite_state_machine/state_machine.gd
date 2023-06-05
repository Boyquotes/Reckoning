extends Node
class_name StateMachine

signal trauma_requisition(trauma: float)
signal transitioned(state_name: String)

var current_direction = 1 : set = _set_current_direction
var double_jumps = 1
var dashs = 1
var working = false

@export var initial_state := NodePath()
@onready var state: State = get_node(initial_state)

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

# funções de delegação de trabalho aos estados
func _unhandled_input(event):
	if working:
		state.handle_input(event)
	
func _process(delta):
	if working:
		state.update(delta)
	
func _physics_process(delta):
	if working:
		state.physics_update(delta)
	
func transition_to(target_state_name: String, msg: Dictionary = {}) -> void:
	if not working:
		return 
		
	if not has_node(target_state_name):
		return
		
	state.exit()
	state = get_node(target_state_name)
	state.enter(msg)
	emit_signal("transitioned", state.name)
	
func trauma_requisiton(trauma: float):
	emit_signal("trauma_requisition", trauma)
###############################################
