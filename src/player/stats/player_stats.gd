extends Resource
class_name PlayerStats

signal health_changed(new_health)

const MAX_HEALTH: int = 100
var _current_health: int

func reset():
	set_health(MAX_HEALTH)
	
func take_damage(amount):
	set_health(max(0, _current_health - amount))
	
func heal(amount):
	set_health(min(MAX_HEALTH, _current_health + amount))
	
func get_max_health():
	return MAX_HEALTH

func get_health():
	return _current_health
	
func set_health(amount):
	_current_health = amount
	emit_signal("health_changed", _current_health)
