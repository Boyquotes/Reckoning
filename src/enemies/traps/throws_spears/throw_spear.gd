extends StaticBody2D

signal create_instance_requisition(instance)

@export var damage: float = 20
@export var direction: Vector2 = Vector2(1, 0)
@export var automatic: bool = false
@export var fire_time: float = 1.0

@onready var texture = $ThrowSpearTexture
@onready var spear_spawn = $SpearSpawn
@onready var fire_timer = $FireTimer

func _ready():
	texture.rotation = direction.angle()
	spear_spawn.position = spear_spawn.position.rotated(direction.angle())


func _on_visible_on_screen_notifier_2d_screen_entered():
	pass # Replace with function body.
