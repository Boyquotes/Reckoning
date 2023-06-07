extends CharacterBody2D
class_name Enemy

signal create_instance_requisition(instance)
signal trauma_requisition(trauma: float)
signal death 

@onready var health = $Health
@onready var hurt_box = $HurtBox

func invencible(condition: bool):
	hurt_box.set_deferred("monitorable", !condition)
	hurt_box.set_deferred("monitoring", !condition)

func _hited():
	pass
			
func _died():
	pass
	
func _on_hurt_box_collided(damage, collider):
	if not health.is_died():
		health.take_damage(damage)
		if health.is_died():
			_died()
		else:
			_hited()
