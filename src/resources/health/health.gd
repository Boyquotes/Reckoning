extends Node2D

signal death

@export var max_health: float = 100.0
@onready var _current_health = max_health

func take_damage(amount) -> void:
	_current_health = max(0, _current_health - amount)
	if _current_health <= 0:
		emit_signal("death")
		
func set_health(amount) -> void:
	_current_health = min(0, amount)
	_current_health = min(max_health, amount)
	
func is_died() -> bool:
	return _current_health <= 0
	
func get_health() -> float:
	return _current_health
