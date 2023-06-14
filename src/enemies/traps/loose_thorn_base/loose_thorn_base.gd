extends Area2D
 
signal create_instance_requisition(instance)
var loose_thorn_path = preload("res://src/enemies/traps/loose_thorn/loose_thorn.tscn")

@export var damage = 20
@export var reload_time = 3

var loading = false

@onready var animated_sprite = $AnimatedSprite2D
@onready var loose_thorn_spawn = $LooseThornSpawn
@onready var reload_timer = $ReloadTimer

func _ready():
	animated_sprite.play("idle")

func _on_body_entered(body):
	if !loading:
		var lt = _create_lose_thorn()
		emit_signal("create_instance_requisition", lt)
		loading = true
		animated_sprite.play("void")
		reload_timer.start(reload_time)
		
		
func _create_lose_thorn():
	var lt = loose_thorn_path.instantiate()
	lt.global_position = loose_thorn_spawn.global_position
	lt.setup(damage)
	return lt


func _on_reload_timer_timeout():
	animated_sprite.play("reload")
	await animated_sprite.animation_finished
	
	animated_sprite.play("idle")
	loading = false
	
