extends Area2D

signal collided(collider: Node2D)

var _damage: float
var _father: Node2D

func setup(damage: float, father: Node2D):
	_damage = damage
	_father = father
	
func _on_area_entered(area):
	var collider = area.collide(_damage, _father)
	emit_signal("collided", collider)
