extends CharacterBody2D

const SPEED = 600

@export var damage: float = 20

# api ########################################
func setup(damage: float):
	self.damage = damage
##############################################
