# meta-name: State Model
# meta-default: true
extends State
# extenda a classe de estado que você quer

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
