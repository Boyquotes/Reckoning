extends Area2D

signal collided(damage: float, collider: Node2D)

var _father: Node2D

func setup(father: Node2D):
	_father = father
	
func collide(damage: float, collider: Node2D):
	emit_signal("collided", damage, collider)
	return _father
