extends Node
class_name StateMachine

signal trauma_requisition(trauma: float)
signal transitioned(state_name: String)

var working = false

@export var initial_state := NodePath()
@onready var state: State = get_node(initial_state)

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
