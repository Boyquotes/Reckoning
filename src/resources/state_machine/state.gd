extends Node
class_name State

var state_machine: StateMachine = null
var persistent_state


func handle_input(_event: InputEvent) -> void:
	pass
	
func update(_delta: float) -> void:
	pass
	
func physics_update(_delta: float) -> void:
	pass
	
func enter(_msg := {}) -> void:
	pass
	
func exit() -> void:
	pass


func _apply_gravity(_delta, _gravity, _gravity_max):
	persistent_state.velocity.y += _gravity * _delta
	persistent_state.velocity.y = min(persistent_state.velocity.y, _gravity_max)
	
func _apply_lerp_x(_weight: float):
	persistent_state.velocity.x = lerp(persistent_state.velocity.x, 0.0, _weight)
	
func _apply_lerp_y(_weight: float):
	persistent_state.velocity.y = lerp(persistent_state.velocity.y, 0.0, _weight)
	
func _apply_move_and_slide():
	persistent_state.move_and_slide()
